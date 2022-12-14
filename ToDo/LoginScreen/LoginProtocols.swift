import Foundation
import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterLoginProtocol {
    var view:PresenterToViewLoginProtocol? {get set}
    var router: PresenterToRouterLoginProtocol? {get set}
    var interactor: PresenterToInteractorLoginProtocol? {get set}
    func touchSignInButton(navigationController:UINavigationController?)
    func touchRegisterButton(navigationController:UINavigationController?)
    func touchSkipButton(navigationController:UINavigationController?)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewLoginProtocol {

    
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorLoginProtocol {
    var presenter: InteractorToPresenterLoginProtocol? {get set}
    func setEnteredApplication()
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterLoginProtocol {

    
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterLoginProtocol {
    static func createModule() -> LoginViewController
    func openRegisterView(navigationController:UINavigationController?)
    func openSignInButton(navigationController:UINavigationController?)
    func openMainScreen(navigationController:UINavigationController?)
}
