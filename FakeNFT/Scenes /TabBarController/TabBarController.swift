import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties

    var servicesAssembly: ServicesAssembly

    // MARK: - TabBar Items
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: Images.profileIcon,
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: Images.catalogIcon,
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: Images.cartIcon,
        tag: 2
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: Images.statisticIcon,
        tag: 3
    )
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    // MARK: - Configure TabBar
    
    private func configureTabBar() {
        view.backgroundColor = .background
        tabBar.unselectedItemTintColor = .primaryForeground
        
        print("🔧 Configuring tab bar")
        
        let profileViewModel = ProfileViewModel(profileService: servicesAssembly.profileService)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        
        let onProfileUpdated: () -> Void = { [weak profileViewModel] in
            print("🔄 Refreshing profile after edit")
            profileViewModel?.fetchProfile()
        }
        
        let navigationHandler = ProfileNavigationHandlerImpl(
            viewController: profileViewController,
            onProfileUpdated: onProfileUpdated
        )
        
        profileViewModel.setNavigationHandler(navigationHandler)
        
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = profileTabBarItem
        profileNavigationController.navigationBar.prefersLargeTitles = false
        
        let catalogController = CatalogViewController(servicesAssembly: servicesAssembly)
        let catalogNavigationController = UINavigationController(rootViewController: catalogController)
        catalogNavigationController.tabBarItem = catalogTabBarItem
        
        let cartController = UIViewController()
        cartController.view.backgroundColor = .white
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        cartNavigationController.tabBarItem = cartTabBarItem
        
        viewControllers = [
            profileNavigationController,
            catalogNavigationController,
            cartNavigationController,
        ]
        
        print("✅ Tab bar configured with \(viewControllers?.count ?? 0) controllers")
    }
}
