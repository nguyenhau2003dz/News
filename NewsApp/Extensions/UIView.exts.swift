//
//  UIView.exts.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//
import UIKit
extension UIView {
    func fillContainer(insets: UIEdgeInsets = .zero) {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        ])
    }
}
