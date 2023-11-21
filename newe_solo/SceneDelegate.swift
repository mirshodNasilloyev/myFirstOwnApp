import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var manager: UserDefaultsManager = UserDefaultsManager.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        configureRootVC()
        window?.makeKeyAndVisible()
    }
    
    //MARK: - Configure Root View Controller
    
    func configureRootVC() {
        if manager.getSelectedCountry() != nil {
            configureTabBar()
        } else {
            showCountryPickerVC()
        }
    }
    
    //MARK: - Country Picker
    
    func showCountryPickerVC() {
        let VC = CountryPickerViewController()
        VC.delegate = self
        let NC = makeNC(with: VC)
        window?.rootViewController = NC
    }

    //MARK: - Configure Tab Bar
    
    func configureTabBar() {
        let tabBar = configureTabBarController()
        window?.rootViewController = tabBar
    }
    
    func configureTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        UITabBar.appearance().backgroundColor = .tabBarBackgroundColor
        UITabBar.appearance().tintColor = .tabBarSelectedColor
        tabBar.tabBar.unselectedItemTintColor = .gray
        tabBar.tabBar.barTintColor = .tabBarBackgroundColor
        tabBar.viewControllers = [makeFeedsNC(), makeBookmarksNC(), makePreferencesNC()]
        return tabBar
    }
    
    //MARK: - Feeds
    
    private func makeFeedsNC() -> UIViewController {
        let VC = makeFeedsVC()
        let NC = makeNC(with: VC)
        NC.tabBarItem = UITabBarItem(
            title: "Feeds",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
        return NC
    }
    
    private func makeFeedsVC() -> FeedsViewController {
        let VC = FeedsViewController()
        VC.title = "Feeds"
        return VC
    }
    
    //MARK: - Bookmarks
    
    private func makeBookmarksNC() -> UIViewController {
        let VC = makeBookmarksVC()
        let NC = makeNC(with: VC)
        NC.tabBarItem = UITabBarItem(
            title: "Bookmarks",
            image: UIImage(systemName: "bookmark.fill"),
            tag: 1
        )
        return NC
    }
    
    private func makeBookmarksVC() -> BookmarksViewController {
        let VC = BookmarksViewController()
        VC.title = "Bookmarks"
        return VC
    }
    
    //MARK: - Preferences
    
    private func makePreferencesNC() -> UIViewController {
        let VC = makePreferencesVC()
        let NC = makeNC(with: VC)
        NC.tabBarItem = UITabBarItem(
            title: "Preferences",
            image: UIImage(systemName: "hammer.fill"),
            tag: 2
        )
        return NC
    }
    
    private func makePreferencesVC() -> PreferencesViewController {
        let VC = PreferencesViewController()
        VC.title = "Preferences"
        return VC
    }
    
    // MARK: - Helpers
    
    private func makeNC(with VC: UIViewController) -> UINavigationController {
        let NC = UINavigationController(rootViewController: VC)
        NC.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        NC.navigationBar.barTintColor = .backgroundColor
        NC.navigationBar.tintColor = .white
        return NC
    }
}

extension SceneDelegate: CountryPickerViewControllerDelegate {
    func didSelectCountry(_ country: Country?) {
        
        manager.saveSelectedCountry(country)
        configureTabBar()
        
    }
    
    func didPressSkipButton() {
        
        manager.saveSelectedCountry(nil)
        configureTabBar()
        
    }
}




    
    



