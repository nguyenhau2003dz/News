//
//  CustomTabbar.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//

import UIKit

protocol CustomTabbarDelegate: AnyObject {
    func didSelectTab(_ tabType: TabType)
}

class CustomTabbar: UIView {
    private var selectedTab: TabType = .home
    private var tabItems: [CustomTabbarItem] = []
    weak var delegate: CustomTabbarDelegate?

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    private func setupView() {
        setupUI()
        setupConstraints()
        createTabItems()
        selectTab(.home)
    }
    
    private func setupUI() {
        backgroundColor = .black
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
    }
    
    private func setupConstraints() {
        addSubview(stackView)
        stackView.fillContainer()
    }
    
    private func createTabItems() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tabItems.removeAll()
        
        for type in TabType.allCases {
            let tabItem = CustomTabbarItem(type: type)
            tabItems.append(tabItem)
            stackView.addArrangedSubview(tabItem.button)
            tabItem.button.addTarget(self, action: #selector(tabButtonTapped(_:)),
                                     for: .touchUpInside)
            tabItem.button.tag = TabType.allCases.firstIndex(of: type) ?? 0
        }
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        if let index = sender.tag as? Int,
           let tabType = TabType.allCases[safe: index] {
            selectTab(tabType)
            delegate?.didSelectTab(tabType)
        }
    }
    
    func selectTab(_ tabType: TabType) {
        selectedTab = tabType
        
        for tabItem in tabItems {
            let isSelected = tabItem.type == selectedTab
            tabItem.setSelected(isSelected)
        }
    }

}
