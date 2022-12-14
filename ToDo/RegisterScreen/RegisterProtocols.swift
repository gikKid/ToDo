import Foundation
import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterRegisterProtocol {
    var view:PresenterToViewRegisterProtocol? {get set}
    var router:PresenterToRouterRegisterProtocol? {get set}
    var interactor:PresenterToInteractorRegisterProtocol? {get set}
    func setLogin(login:String?)
    func setMail(mail:String?)
    func setPassword(password:String?)
    func checkConfirmPassword(confirmPassword:String?)
    func userTapConfirmButton()
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewRegisterProtocol {
    func errorRegister(errorText:String,errorType:ErrorType)
    func enableConfirmButton()
    func onFailureRegistered(errorText:String)
    func validField(field:RegisterField)
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorRegisterProtocol {
    var presenter:InteractorToPresenterRegisterProtocol? {get set}
    func registeringUser(user:RegisterBody)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterRegisterProtocol {
    func successfulyRegistered()
    func failureRegistered(errorText:String)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterRegisterProtocol {
    static func createModule() -> RegisterViewController
    func showSignInScreen(registerViewController:RegisterViewController)
}
