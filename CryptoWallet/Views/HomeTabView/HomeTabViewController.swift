import UIKit

final class HomeTabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let viewController1 = EmptyViewController()
        let viewController2 = EmptyViewController()
        let viewController3 = EmptyViewController()
        let viewController4 = EmptyViewController()
        let viewController5 = EmptyViewController()
        
        viewController1.tabBarItem.image = UIImage(resource: .homeIcon)
        viewController2.tabBarItem.image = UIImage(resource: .charIcon)
        viewController3.tabBarItem.image = UIImage(resource: .walletIcon)
        viewController4.tabBarItem.image = UIImage(resource: .pageIcon)
        viewController5.tabBarItem.image = UIImage(resource: .personIcon)
        
        let navigation1 = UINavigationController(rootViewController: viewController1)
        let navigation2 = UINavigationController(rootViewController: viewController2)
        let navigation3 = UINavigationController(rootViewController: viewController3)
        let navigation4 = UINavigationController(rootViewController: viewController4)
        let navigation5 = UINavigationController(rootViewController: viewController5)
        
        tabBar.tintColor = .loginButton
        tabBar.backgroundColor = .white
        setViewControllers([navigation1, navigation2, navigation3, navigation4, navigation5], animated: true)
    }
}
