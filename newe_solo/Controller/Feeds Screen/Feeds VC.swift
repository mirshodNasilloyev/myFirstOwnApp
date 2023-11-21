import UIKit
import WebKit
import RxSwift
import RxCocoa

class FeedsViewController: UITableViewController, WKNavigationDelegate {
    
    //MARK: - Properties
    
    enum SectionType { case main }
    private var dataSource: UITableViewDiffableDataSource<SectionType, Feed>!
    
    private let service = FeedsListService()
    
    private var manager: FeedListManager!
    
    private var feeds: [Feed] = []
    
    private var filteredFeeds = [Feed]() {
        didSet {
            applySnapshot(for: filteredFeeds)
        }
    }
    
    var selectedCountry: Country?
    
    var isLoadingMore = false
    
    private let userDefaults = UserDefaultsManager.shared
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        configureManager()
        configureView()
        manager.start()
    }
    
    // MARK: Manager Configuration
    
    private func configureManager() {
        
        manager = FeedListManager(service: service)
        
        manager.completionHandler = { [weak self] result in
            
            switch result {
                
            case .success(let feeds):
                
                self?.feeds = feeds
                self?.filteredFeeds = feeds
                self?.applySnapshot(for: feeds)
                
            case .failure(let error):
                
                print("Error fetching feeds: \(error)")
                
            }
        }
    }
    
    private func refresh() {
        
        feeds = []
        filteredFeeds = []
        manager.start()
        
    }
    
    //MARK: - View Configuration
    
    private func configureView() {
        
        configureTableView()
        configureSearchBar()
        configureItem()
        
    }
    
    //MARK: - Apply Snapshot
    
    private func applySnapshot(for feeds: [Feed]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Feed>()
        snapshot.appendSections([.main])
        snapshot.appendItems(feeds)
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
}


//MARK: - Table View Configuration

extension FeedsViewController {
    
    private func configureTableView() {
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        dataSource = UITableViewDiffableDataSource<SectionType, Feed>(tableView: tableView, cellProvider: { tableView, indexPath, feed in
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
            cell.setContent(with: feed)
            return cell
            
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feed = filteredFeeds[indexPath.row]
        
        if let url = URL(string: feed.url) {
            
            let webVC = WebViewController()
            webVC.url = url
            navigationController?.pushViewController(webVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == filteredFeeds.count - 1 && !isLoadingMore {
            
            isLoadingMore = true
            service.loadMoreFeeds()
            
        }
    }
}

//MARK: - Service Delegate

extension FeedsViewController: FeedsListServiceDelegate {
    
    func didFetchFeeds(_ feeds: [FeedDTO]) {
        
        let newFeeds = feeds.map { Feed(
            
            url: $0.url,
            image: $0.image,
            country: $0.country,
            category: $0.category,
            title: $0.title,
            description: $0.description,
            isBookmarked: false)
            
        }
        
        self.feeds.append(contentsOf: newFeeds)
        filteredFeeds = self.feeds
        
        DispatchQueue.main.async {
            
            self.isLoadingMore = false
            self.tableView.reloadData()
            
        }
    }
    
    func didFailWithError(_ error: Error) {}
    
}

//MARK: - Search Bar Configuration

extension FeedsViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        
        let searchBar = UISearchController(searchResultsController: nil)
        let searchIcon = UIImage(systemName: "magnifyingglass")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        searchBar.searchBar.setImage(searchIcon, for: .search, state: .normal)
        searchBar.searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchBar.delegate = self
        searchBar.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search ...",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        )
        
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredFeeds = feeds.filter({$0.title.lowercased().contains(searchText.lowercased())})
        
        if searchBar.text?.count == 0 {
            filteredFeeds = feeds
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        filteredFeeds = feeds
        
    }
}

//MARK: - Item Configuration

extension FeedsViewController {
    
    private func configureItem() {
        
        if let selectedCountry = userDefaults.getSelectedCountry() {
            
            let image = UIImage(named: "\(selectedCountry.flag)")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            
            let leftBarButton = UIBarButtonItem(customView: imageView)
            leftBarButton.action = #selector(didTapFlag)
            
            let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 60)
            let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 40)
            
            heightConstraint.isActive = true
            widthConstraint.isActive = true
            
            navigationItem.leftBarButtonItem = leftBarButton
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFlag))
            imageView.addGestureRecognizer(tapRecognizer)
            
        } else {
            
            navigationItem.leftBarButtonItem = nil
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didTapFilter))
    }
    
    //MARK: Flag
    
    @objc func didTapFlag() {
        
        let alertController = UIAlertController(title: "Change Country", message: "Do you want to change the selected country?", preferredStyle: .actionSheet)
        
        let changeCountryAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.changeCountry()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(changeCountryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func changeCountry() {
        
        let VC = CountryPickerViewController()
        VC.delegate = self
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    //MARK: - Filter
    
    @objc func didTapFilter() {
        
        let actionSheet = UIAlertController(title: "By category", message: nil, preferredStyle: .actionSheet)
        
        let categories = ["All", "General", "Business", "Sports"]
        
        for category in categories {
            
            let action = UIAlertAction(title: category, style: .default) { [weak self] _ in
                self?.filterFeeds(byCategory: category.lowercased())
            }
            
            actionSheet.addAction(action)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
        
    }
    
    private func filterFeeds(byCategory category: String) {
        
        filteredFeeds = category == "all" ? feeds : feeds.filter { $0.category.lowercased() == category }
        
    }
}

extension FeedsViewController: CountryPickerViewControllerDelegate {
    func didSelectCountry(_ country: Country?) {
        userDefaults.saveSelectedCountry(country)
        selectedCountry = country
        configureItem()
        navigationController?.popViewController(animated: true)
        
        refresh()
    }
    
    func didPressSkipButton() {
        
        userDefaults.saveSelectedCountry(nil)
        configureItem()
        navigationController?.popViewController(animated: true)
        
    }
}
