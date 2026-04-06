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
        
        let profileController = UIViewController()  //изменить на свой
        profileController.tabBarItem = profileTabBarItem

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )   //изменить на свой
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartViewModel = CartViewModel(cartService: servicesAssembly.cartService)
        let cartViewController = CartViewController(viewModel: cartViewModel)
        cartViewController.tabBarItem = cartTabBarItem
        
        let statisticsController = UIViewController()   //изменить на свой
        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [profileController, catalogController, cartViewController, statisticsController]
    }
}
