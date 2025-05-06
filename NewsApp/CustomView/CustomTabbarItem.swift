//
//  CustomTabbarItem.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//

import UIKit

enum TabType: String, CaseIterable {
    case home
    case discovery
    case notice
    case profile
    
    func title() -> String {
        return self.rawValue.capitalized
    }
    
    func icon() -> UIImage? {
        return UIImage(named: self.rawValue)
    }
    
    func selectedIcon() -> UIImage? {
        return UIImage(named: "\(self.rawValue)_selected")
    }
}
class CustomTabbarItem {
    let type: TabType
    let button: UIButton
    
    init(type: TabType) {
        self.type = type
        self.button = UIButton()
        setupButton()
    }
    
    private func setupButton() {
        button.setImage(type.icon(), for: .normal)
        
        button.setTitle(type.title(), for: .normal)
        button.setTitleColor(UIColor(named: "hex_Grey"), for: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 12)
        
        button.titleEdgeInsets = UIEdgeInsets(top: 30, left: -8, bottom: 0, right: 21)
        button.imageEdgeInsets = UIEdgeInsets(top: -20, left: -33, bottom: 0, right: -70)
        
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        button.imageView?.contentMode = .center
        button.titleLabel?.textAlignment = .center
    }
    
    func setSelected(_ isSelected: Bool) {
        if isSelected {
            button.setImage(type.selectedIcon(), for: .normal)
            button.tintColor = UIColor(named: "hex_Orange")
            button.setTitleColor(UIColor(named: "hex_Orange"), for: .normal)
        } else {
            button.setImage(type.icon(), for: .normal)
            button.tintColor = UIColor(named: "hex_Grey")
            button.setTitleColor(UIColor(named: "hex_Grey"), for: .normal)
        }
    }
}
