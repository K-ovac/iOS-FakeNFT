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
        view.backgroundColor = UIColor.background
        tabBar.unselectedItemTintColor = UIColor.segmentActive
        
        let profileController = UIViewController()  //изменить на свой
        profileController.tabBarItem = profileTabBarItem

        let catalogController = UINavigationController(
            rootViewController: CatalogViewController(
                servicesAssembly: servicesAssembly
            ),
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartController = UIViewController() //изменить на свой
        cartController.tabBarItem = cartTabBarItem
        
        let statisticsController = UIViewController()   //изменить на свой
        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [profileController, catalogController, cartController, statisticsController]
    }
}
