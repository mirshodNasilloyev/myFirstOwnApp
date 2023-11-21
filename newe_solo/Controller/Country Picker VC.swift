import UIKit
import RxSwift
import RxCocoa

protocol CountryPickerViewControllerDelegate: AnyObject {
    
    func didSelectCountry(_ country: Country?)
    
    func didPressSkipButton()
    
}

class CountryPickerViewController: UITableViewController {
    
    // MARK: Properties
    
    weak var delegate: CountryPickerViewControllerDelegate?
    
    private var countries = [Country]()
    
    private var filteredCountries = [Country]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var isSkipButtonPressed = false
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        configureView()
        configureSearchBar()
        
    }

    @objc private func didTapSkip() {
        isSkipButtonPressed = true
        delegate?.didPressSkipButton()
    }

    // MARK: Private methods
    
    private func configureView() {
        
        configureTableView()
        configureCountries()
        configureNavigationBar()
        
    }
    
    private func configureCountries() {
        
        countries = CountriesDataSource.getCountries()
        filteredCountries = countries
        
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Skip",
            style: .plain,
            target: self,
            action: #selector(didTapSkip)
        )
    }
}

//MARK: - Table View Configuration

extension CountryPickerViewController {
    
    private func configureTableView() {
        
        tableView.register(CountryCell.self, forCellReuseIdentifier: "CountryCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if isSkipButtonPressed {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        let country = filteredCountries[indexPath.row]
        cell.setContent(with: country)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCountries.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = filteredCountries[indexPath.row]
        delegate?.didSelectCountry(selectedCountry)
    }
}

//MARK: Search Bar Configuration

extension CountryPickerViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        
        let searchBar = UISearchController(searchResultsController: nil)
        let searchIcon = UIImage(systemName: "magnifyingglass")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        searchBar.searchBar.setImage(searchIcon, for: .search, state: .normal)
        searchBar.searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchBar.delegate = self
        searchBar.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search ...",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.white]
        )
        
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCountries = countries.filter({$0.name.lowercased().contains(searchText.lowercased())})
        
        if searchBar.text?.count == 0 {
            filteredCountries = countries
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        filteredCountries = countries
        
    }
    
}
