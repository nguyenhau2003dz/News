//
//  MainCoodinator.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//
import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    var navigationController: UINavigationController
    
    private var homeCoordinator: HomeCoordinator?
    private var discoveryCoordinator: DiscoveryCoordinator?
    private var noticeCoordinator: NoticeCoordinator?
    private var profileCoordinator: ProfileCoordinator?
    private var mainViewController: MainViewController?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        mainViewController = MainViewController()
        let viewControllers = createAndConfigureViewControllers()
        mainViewController?.setViewControllers(viewControllers)
        
        if let mainVC = mainViewController {
            print(mainVC)
            navigationController.viewControllers = [mainVC]
        } else {
            navigationController.viewControllers = [UIViewController()]
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func createAndConfigureViewControllers() -> [UIViewController] {
        let homeVC = HomeViewController()
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeVC.coordinator = homeCoordinator
        homeCoordinator.parentCoordinator = self
        addChildCoordinator(homeCoordinator)
        self.homeCoordinator = homeCoordinator
        homeCoordinator.start()
        
        let discoveryVC = DiscoveryViewController()
        let discoveryCoordinator = DiscoveryCoordinator(navigationController: navigationController)
        discoveryVC.coordinator = discoveryCoordinator
        discoveryCoordinator.parentCoordinator = self
        addChildCoordinator(discoveryCoordinator)
        self.discoveryCoordinator = discoveryCoordinator
        discoveryCoordinator.start()
        
        let noticeVC = NoticeViewController()
        let noticeCoordinator = NoticeCoordinator(navigationController: navigationController)
        noticeVC.coordinator = noticeCoordinator
        noticeCoordinator.parentCoordinator = self
        addChildCoordinator(noticeCoordinator)
        self.noticeCoordinator = noticeCoordinator
        noticeCoordinator.start()
        
        let profileVC = ProfileViewController()
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileVC.coordinator = profileCoordinator
        profileCoordinator.parentCoordinator = self
        addChildCoordinator(profileCoordinator)
        self.profileCoordinator = profileCoordinator
        profileCoordinator.start()
        
        return [homeVC, discoveryVC, noticeVC, profileVC]
    }
        
    func childDidFinish(_ child: Coordinator?) {
        if let child = child {
            removeChildCoordinator(child)
        }
    }
}
