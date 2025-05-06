//
//  MainViewController.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
    private var viewControllers: [UIViewController] = []
    
    private lazy var contentView = UIView()
    private lazy var customTabbar = CustomTabbar()
    
    private var currentViewController: UIViewController?
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showViewController(at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
    
    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(contentView)
        view.addSubview(customTabbar)
                
        contentView.translatesAutoresizingMaskIntoConstraints = false
        customTabbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        contentView.topAnchor.constraint(equalTo: view.topAnchor),
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        contentView.bottomAnchor.constraint(equalTo: customTabbar.topAnchor),
                
        customTabbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        customTabbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        customTabbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        customTabbar.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        customTabbar.delegate = self
    }
    
    private func showViewController(at index: Int) {
        guard index < viewControllers.count else {
            return
        }
        currentIndex = index
        
        if let currentVC = currentViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
            self.currentViewController = nil
        }
        
        let newVC = viewControllers[index]
        addChild(newVC)
        
        view.layoutIfNeeded()
        
        newVC.view.frame = contentView.bounds
        contentView.addSubview(newVC.view)
        newVC.didMove(toParent: self)
        currentViewController = newVC
    }
}
extension MainViewController: CustomTabbarDelegate {
    func didSelectTab(_ tabType: TabType) {
        if let index = TabType.allCases.firstIndex(of: tabType) {
            showViewController(at: index)
        }
    }
}
