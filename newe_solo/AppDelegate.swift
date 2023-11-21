import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var  window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let feedsVC = FeedsViewController()
        let NC = UINavigationController(rootViewController: feedsVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NC
        window?.makeKeyAndVisible()
        
        return true
        
    }
    
}

