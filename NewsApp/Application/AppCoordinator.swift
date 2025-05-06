//
//  AppCoordinator.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showMainFlow()
        window.makeKeyAndVisible()
    }
    
    private func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
    
    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(window: window)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    private func showMainFlow() {
        let coordinator = MainCoordinator(window: window)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didFinishAuthentication() {
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        childCoordinators.removeAll { $0 is AuthCoordinator }
        showMainFlow()
    }
}

