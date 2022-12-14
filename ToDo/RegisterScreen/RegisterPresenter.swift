import UIKit

final class RegisterPresenter:ViewToPresenterRegisterProtocol {
    var view: PresenterToViewRegisterProtocol?
    var router: PresenterToRouterRegisterProtocol?
    var interactor: PresenterToInteractorRegisterProtocol?
    var user = RegisterBody(username: "", email: "", password: "")
    let registerViewController:RegisterViewController
    
    init(registerViewController:RegisterViewController) {
        self.registerViewController = registerViewController
    }
    
    func setLogin(login: String?) {
        guard let login = login, !login.isEmpty else {
            view?.errorRegister(errorText: "login field is empty!", errorType: .login)
            return
        }
        guard login.count > 5 else {
            view?.errorRegister(errorText: "login must be more 5 symbols", errorType: .login)
            return
        }
        view?.validField(field: .login)
        self.user.username = login
    }
    
    func setMail(mail: String?) {
        guard let mail = mail, !mail.isEmpty else {
            view?.errorRegister(errorText: "mail field is empty!", errorType: .mail)
            return
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        if !isValidRegEx(regexStr: emailRegEx, object: mail) {
            view?.errorRegister(errorText: "mail isnt valid", errorType: .mail)
            return
        }
        view?.validField(field: .mail)
        self.user.email = mail
    }
    
    private func isValidRegEx(regexStr:String,object:String) -> Bool{
        let predicate = NSPredicate(format: "SELF MATCHES %@",regexStr)
        return predicate.evaluate(with: object)
    }
    
    func setPassword(password: String?) {
        guard let password = password, !password.isEmpty else {
            view?.errorRegister(errorText: "password field is empty!", errorType: .password)
            return
        }
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        if !isValidRegEx(regexStr: passRegEx, object: password) {
            view?.errorRegister(errorText: "password must be minimum 8 characters, at least 1 Alphabet and 1 Number!", errorType: .password)
            return
        }
        view?.validField(field: .password)
        self.user.password = password
    }
    
    
    func checkConfirmPassword(confirmPassword: String?) {
        guard let confirmPassword = confirmPassword, confirmPassword == self.user.password else {
            view?.errorRegister(errorText: "passwords dont match", errorType: .conflictPasswords)
            return
        }
        view?.validField(field: .confirmPassword)
        view?.enableConfirmButton()
    }
    
    func userTapConfirmButton() {
        interactor?.registeringUser(user: user)
    }
}

extension RegisterPresenter:InteractorToPresenterRegisterProtocol {
    func successfulyRegistered() {
        router?.showSignInScreen(registerViewController: registerViewController)
    }
    
    func failureRegistered(errorText: String) {
        view?.onFailureRegistered(errorText: errorText)
    }
    
    
}
