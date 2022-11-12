import UIKit

final class CreateTaskRouter:PresenterToRouterCreateTaskProtocol {
    static func createModule(category:CategoryCoreData,section:Int) -> CreateTaskViewController {
        let createTaskViewController = CreateTaskViewController(section: section, category: category)
        
        let createTaskPresenter: (ViewToPresenterCreateTaskProtocol & InteractorToPresenterCreateTaskProtocol) = CreateTaskPresenter()
        
        createTaskViewController.presenter = createTaskPresenter
        createTaskViewController.presenter?.view = createTaskViewController
        createTaskViewController.presenter?.interactor = CreateTaskInteractor()
        createTaskViewController.presenter?.router = CreateTaskRouter()
        createTaskViewController.presenter?.interactor?.presenter = createTaskPresenter
        return createTaskViewController
    }
    
    
}
