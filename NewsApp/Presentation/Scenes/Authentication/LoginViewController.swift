//
//  LoginViewController.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()
    weak var coordinator: AuthCoordinator?

    private let titleLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let hideStackView = UIStackView()
    private let hideImageView = UIImageView()
    private let hideLabel = UILabel()
    private let loginButton = GradientButton()
    private let registerButton = UIButton()
    private let forgotPassButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hexBackGround
        setupUI()
        setupActions()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            if let coordinator = self.coordinator {
                coordinator.didFinishLogin()
            } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first {
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                let mainCoordinator = MainCoordinator(window: window)
                window.rootViewController = nil
                mainCoordinator.start()
            }
        }

        viewModel.onLoginFailure = { [weak self] errorMessage in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(
                title: "Login Error",
                message: errorMessage,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        hideImageView.isUserInteractionEnabled = true
        hideImageView.addGestureRecognizer(tapGesture)
        loginButton.addTarget(self, action: #selector(loginAccount), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerAccount), for: .touchUpInside)
        forgotPassButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
    }

    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        hideLabel.text = passwordTextField.isSecureTextEntry ? "Show password" : "Hide password"
    }

    @objc private func loginAccount() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        viewModel.login(email: email, password: password)
    }

    @objc private func registerAccount() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func forgotPassword() {
        let alert = UIAlertController(
            title: "Password Recovery",
            message: "Please enter your email to recover your password",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            if let email = self.emailTextField.text, !email.isEmpty {
                textField.text = email
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let resetAction = UIAlertAction(title: "Send", style: .default) { [weak self] _ in
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                self?.showAlert(title: "Error", message: "Please enter email")
                return
            }

            if !(self?.viewModel.isValidEmail(email) ?? false) {
                self?.showAlert(title: "Error", message: "Invalid email format")
                return
            }

            self?.activityIndicator.startAnimating()

            Auth.auth().sendPasswordReset(withEmail: email) { error in
                self?.activityIndicator.stopAnimating()
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self?.showAlert(title: "Success", message: "Password reset link has been sent to your email")
                }
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(resetAction)
        present(alert, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupUI() {
        hideStackView.axis = .horizontal
        hideStackView.spacing = 6
        hideStackView.alignment = .center
        hideStackView.distribution = .fill
        hideStackView.addArrangedSubview(hideImageView)
        hideStackView.addArrangedSubview(hideLabel)

        [titleLabel, emailTextField, passwordTextField,
         hideStackView, loginButton, registerButton, forgotPassButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        applyStyles()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 58),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            emailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),

            hideStackView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            hideStackView.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),

            loginButton.topAnchor.constraint(equalTo: hideStackView.bottomAnchor, constant: 35),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            registerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),

            forgotPassButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            forgotPassButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            forgotPassButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            forgotPassButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
        ])
    }

    private func applyStyles() {
        titleLabel.text = "Login"
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        titleLabel.textColor = .white

        applyTextFieldStyle(emailTextField, placeholder: "Email")
        applyTextFieldStyle(passwordTextField, placeholder: "Password")
        passwordTextField.isSecureTextEntry = true

        hideImageView.image = UIImage(named: "hideImage")
        hideImageView.contentMode = .scaleAspectFill
        hideImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        hideImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        hideLabel.text = "Hide password"
        hideLabel.textColor = .hexDarkGrey
        hideLabel.font = .systemFont(ofSize: 18, weight: .medium)

        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.label, for: .normal)
        loginButton.setGradientColors(startColor: .hexBrown, endColor: .hexDarkRed)
        loginButton.setGradientDirection(startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true

        [registerButton, forgotPassButton].forEach {
            $0.setTitleColor(.label, for: .normal)
            $0.backgroundColor = .hexDarkGrey
            $0.layer.cornerRadius = 10
        }

        registerButton.setTitle("Register new account", for: .normal)
        forgotPassButton.setTitle("Forgot password", for: .normal)
    }

    private func applyTextFieldStyle(_ textField: UITextField, placeholder: String) {
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(.hexDarkText)]
        )
        textField.textColor = UIColor(.hexDarkText)
        textField.backgroundColor = .hexGrey
    }
}
