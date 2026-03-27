import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "catalogTabBarItem"),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "cartTabBarItem"),
        tag: 2
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        view.backgroundColor = UIColor.background
        tabBar.unselectedItemTintColor = .black
        
        print("🔧 Configuring tab bar")
        
        let profileViewModel = ProfileViewModel(profileService: servicesAssembly.profileService)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        let navigationHandler = ProfileNavigationHandlerImpl(viewController: profileViewController)
        
        profileViewModel.setNavigationHandler(navigationHandler)
        
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = profileTabBarItem
        profileNavigationController.navigationBar.prefersLargeTitles = false
        
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        let catalogNavigationController = UINavigationController(rootViewController: catalogController)
        catalogNavigationController.tabBarItem = catalogTabBarItem
        
        let cartController = UIViewController()
        cartController.view.backgroundColor = .white
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        cartNavigationController.tabBarItem = cartTabBarItem
        
        let statisticsController = UIViewController()
        statisticsController.view.backgroundColor = .white
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)
        statisticsNavigationController.tabBarItem = statisticsTabBarItem
        
        viewControllers = [
            profileNavigationController,
            catalogNavigationController,
            cartNavigationController,
            statisticsNavigationController
        ]
        
        print("✅ Tab bar configured with \(viewControllers?.count ?? 0) controllers")
    }
}
