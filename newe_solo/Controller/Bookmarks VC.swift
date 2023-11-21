import UIKit
import WebKit
import RxSwift
import RxCocoa

class BookmarksViewController: UITableViewController, WKNavigationDelegate {
    
    //MARK: - Properties
    
    private let service = FeedsListService()
    
    
    private var feeds: [Feed] = []
        
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        configureTableView()
        
    }
}

extension BookmarksViewController {
    
    func configureTableView() {
        
        tableView.register(BookmarkCell.self, forCellReuseIdentifier: "BookmarkCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! BookmarkCell
        let feed = feeds[indexPath.row]
        cell.setContent(with: feed)
        return cell
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feed = feeds[indexPath.row]
        
        if let url = URL(string: feed.url) {
            
            let webVC = WebViewController()
            webVC.url = url
            navigationController?.pushViewController(webVC, animated: true)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


