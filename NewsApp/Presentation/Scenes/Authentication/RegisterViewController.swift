//
//  RegisterViewController.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    let viewModel = RegisterViewModel()
    weak var coordinator: AuthCoordinator?

    let titleLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let hideStackView = UIStackView()
    let hideImageView = UIImageView()
    let hideLabel = UILabel()
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let policyLabel = UILabel()
    let registerButton = GradientButton()
    let havedButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupBindings()
    }

    func setupBindings() {
        viewModel.onErrorMessage = { [weak self] message in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default))
            self?.present(alert, animated: true)
        }

        viewModel.onRegisterSuccess = { [weak self] in
            let alert = UIAlertController(title: "Success", message: "Registration successful!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(alert, animated: true)
        }
    }

    @objc func registerAccount() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        viewModel.register(email: email, password: password, firstName: firstName, lastName: lastName)
    }

    @objc func havedAccount() {
        navigationController?.popViewController(animated: true)
    }

    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
    }

    func setupUI() {
        navigationItem.hidesBackButton = true

        [titleLabel, emailTextField, passwordTextField, hideStackView,
         firstNameTextField, lastNameTextField, policyLabel,
         registerButton, havedButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        hideImageView.isUserInteractionEnabled = true
        hideImageView.addGestureRecognizer(tapGesture)
        registerButton.addTarget(self, action: #selector(registerAccount), for: .touchUpInside)
        havedButton.addTarget(self, action: #selector(havedAccount), for: .touchUpInside)

        hideStackView.axis = .horizontal
        hideStackView.spacing = 6
        hideStackView.alignment = .center
        hideStackView.distribution = .fill
        hideStackView.translatesAutoresizingMaskIntoConstraints = false
        hideStackView.addArrangedSubview(hideImageView)
        hideStackView.addArrangedSubview(hideLabel)

        titleLabel.text = "Register"
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        titleLabel.textColor = .label

        styleTextField(emailTextField, placeholder: "Email")
        styleTextField(passwordTextField, placeholder: "Password")
        styleTextField(firstNameTextField, placeholder: "First name")
        styleTextField(lastNameTextField, placeholder: "Last name")
        passwordTextField.isSecureTextEntry = true

        hideImageView.image = UIImage(named: "hideImage")
        hideImageView.contentMode = .scaleAspectFill
        hideImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        hideImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        hideLabel.text = "Hide password"
        hideLabel.textColor = .hexGrey
        hideLabel.font = .systemFont(ofSize: 18, weight: .medium)

        policyLabel.text = """
        By registering and using this application, you agree and acknowledge that you understand the \
        End-User License Agreement (EULA) & Privacy Policy. Click here to see detail.
        """
        policyLabel.textColor = .red
        policyLabel.font = .systemFont(ofSize: 15, weight: .medium)
        policyLabel.numberOfLines = 0

        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.label, for: .normal)
        registerButton.setGradientColors(startColor: .hexBrown, endColor: .hexDarkRed)
        registerButton.setGradientDirection(startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        registerButton.layer.cornerRadius = 10
        registerButton.clipsToBounds = true

        havedButton.setTitle("Already have an account? Login", for: .normal)
        havedButton.setTitleColor(.label, for: .normal)
        havedButton.backgroundColor = .hexDarkGrey
        havedButton.layer.cornerRadius = 10

        setupConstraints()
    }

    private func styleTextField(_ textField: UITextField, placeholder: String) {
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.textColor = .hexDarkText
        textField.backgroundColor = .hexDarkGrey
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(.hexDarkText)]
        )
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 58),
            emailTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 13),
            emailTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -13),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),

            hideStackView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            hideStackView.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),

            firstNameTextField.topAnchor.constraint(equalTo: hideStackView.bottomAnchor, constant: 35),
            firstNameTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            firstNameTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            firstNameTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),

            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            lastNameTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            lastNameTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),

            policyLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 18),
            policyLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            policyLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),

            registerButton.topAnchor.constraint(equalTo: policyLabel.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            registerButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),

            havedButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            havedButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            havedButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            havedButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
        ])
    }
}
