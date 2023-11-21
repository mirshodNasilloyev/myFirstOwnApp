import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    // MARK: - Country
    
    func saveSelectedCountry(_ country: Country?) {
        
        if let country = country {
            
            UserDefaults.standard.set(country.name, forKey: "SelectedCountry")
            UserDefaults.standard.set(country.code, forKey: "SelectedCountryCode")
            UserDefaults.standard.set(country.flag, forKey: "SelectedCountryFlag")
            
        } else {
            
            UserDefaults.standard.removeObject(forKey: "SelectedCountry")
            UserDefaults.standard.removeObject(forKey: "SelectedCountryCode")
            UserDefaults.standard.removeObject(forKey: "SelectedCountryFlag")
            
        }
    }
    
    func getSelectedCountry() -> Country? {
        
        if let countryName = UserDefaults.standard.string(forKey: "SelectedCountry"),
           let countryCode = UserDefaults.standard.string(forKey: "SelectedCountryCode"),
           let countryFlag = UserDefaults.standard.string(forKey: "SelectedCountryFlag") {
            
            let country = Country(name: countryName, code: countryCode, flag: countryFlag)
            
            return country
            
        }
        
        return nil
        
    }
    
    //MARK: - Switch State
    
    func saveSwitchState(_ switchState: Bool) {
        UserDefaults.standard.set(switchState, forKey: "SwitchStateKey")
    }
    
    func getSwitchState() -> Bool {
        return UserDefaults.standard.bool(forKey: "SwitchStateKey")
    }
}
