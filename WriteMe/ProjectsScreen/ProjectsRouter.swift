import UIKit

final class ProjectsRouter:PresenterToRouterProjectsProtocol {
    func showMyBlogScreen(projectsViewController: ProjectsViewController) {
        let myBlogViewController = MyBlogRouter.createModule()
        projectsViewController.navigationController?.pushViewController(myBlogViewController, animated: true)
    }
    
    func showProductivityScreen(projectsViewController: ProjectsViewController) {
        let productivityViewController = ProductivityRouter.createModule()
        projectsViewController.navigationController?.pushViewController(productivityViewController, animated: true)
    }
    
    func showCalendarScreen(projectsViewController:ProjectsViewController) {
        let calendarViewController = CalendarRouter.createModule()
        projectsViewController.navigationController?.pushViewController(calendarViewController, animated: true)
    }
    
    func showIncomingProject(project: ProjectCoreData, projectsViewController: ProjectsViewController) {
        let incomingProjectViewController = PrjRouter.createModule(project: project)
        projectsViewController.navigationController?.pushViewController(incomingProjectViewController, animated: true)
    }
    
    func onShowErrorAlert(errorText: String, projectsViewController: ProjectsViewController) {
        let alertController = createInfoAlert(messageText: errorText, titleText: Resources.Titles.errorTitle)
        projectsViewController.present(alertController,animated: true)
    }
    
    static func createModule() -> ProjectsViewController {
        let projectsViewController = ProjectsViewController()
        
        let projectsPresenter: (ViewToPresenterProjectsProtocol & InteractorToPresenterProjectsProtocol) = ProjectsPresenter()
        
        projectsViewController.presenter = projectsPresenter
        projectsViewController.presenter?.view = projectsViewController
        projectsViewController.presenter?.interactor = ProjectsInteractor()
        projectsViewController.presenter?.router = ProjectsRouter()
        projectsViewController.presenter?.interactor?.presenter = projectsPresenter
        return projectsViewController
    }
    
    func showProjectScreen(projectsViewController:ProjectsViewController,project: ProjectCoreData) {
        let prjViewController = PrjRouter.createModule(project: project)
        projectsViewController.navigationController?.pushViewController(prjViewController, animated: true)
    }
}
