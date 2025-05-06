//
//  HomeViewController.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//

import UIKit

class HomeViewController: UIViewController {
    var coordinator: HomeCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemBlue

        let label = UILabel()
        label.text = "Đây là màn hình Home"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center

        let button = UIButton(type: .system)
        button.setTitle("Nhấn vào tôi", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        view.addSubview(label)
        view.addSubview(button)

        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 160),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func buttonTapped() {
        print("Button trong HomeViewController đã được nhấn")
    }
}
