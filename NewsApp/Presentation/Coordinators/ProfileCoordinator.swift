//
//  ProfileCoordinator.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    let navigationController: UINavigationController
    weak var parentCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // method này vẫn được giữ để tuân theo giao diện Coordinator
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
