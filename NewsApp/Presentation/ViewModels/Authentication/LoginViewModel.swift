import Foundation
import FirebaseAuth

class LoginViewModel {

    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?

    func validateLogin(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            onLoginFailure?("Email và mật khẩu không được để trống.")
            return false
        }

        guard isValidEmail(email) else {
            onLoginFailure?("Định dạng email không hợp lệ.")
            return false
        }

        guard password.count >= 6 else {
            onLoginFailure?("Mật khẩu phải có ít nhất 6 ký tự.")
            return false
        }

        return true
    }

    func login(email: String, password: String) {
        guard validateLogin(email: email, password: password) else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.onLoginFailure?(error.localizedDescription)
            } else {
                self?.onLoginSuccess?()
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
