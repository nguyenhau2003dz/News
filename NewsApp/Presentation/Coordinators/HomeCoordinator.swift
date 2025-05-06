//
//  HomeCoordinator.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    let navigationController: UINavigationController
    var parentCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
