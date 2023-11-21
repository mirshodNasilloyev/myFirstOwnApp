import UIKit
import RxSwift
import RxCocoa

class PreferencesViewController: UITableViewController {
    
    //MARK: - Properties
    
    private let userDefaults = UserDefaultsManager.shared
    
    var selectedCountry: Country?
    
    //MARK: - View Lifesycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        configureTableView()
        
    }
    
    //MARK: - Table View Configuration
    
    private func configureTableView() {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SwitchControlCell.self, forCellReuseIdentifier: "SwitchControlCell")
        tableView.register(CountryEditorCell.self, forCellReuseIdentifier: "CountryEditorCell")
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchControlCell", for: indexPath) as! SwitchControlCell
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryEditorCell", for: indexPath) as! CountryEditorCell
            cell.accessoryType = .disclosureIndicator
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            
            tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true, completion: nil)
            
            let VC  = CountryPickerViewController()
            VC.delegate = self
            navigationController?.pushViewController(VC, animated: true)
            
        }
    }
}

//MARK: - Country Picker VC Delegate

extension PreferencesViewController: CountryPickerViewControllerDelegate {
    
    func didSelectCountry(_ country: Country?) {
        
        userDefaults.saveSelectedCountry(country)
        selectedCountry = country
        navigationController?.popViewController(animated: true)
        
    }
    
    func didPressSkipButton() {
        
        userDefaults.saveSelectedCountry(nil)
        navigationController?.popViewController(animated: true)
                
    }
}

