import UIKit
import CoreData

protocol CategoryTableSectionHeaderViewProtocol {
    func renameSection(category:CategoryCoreData)
    func deleteSection(category:CategoryCoreData)
}

class CategoryTableSectionHeaderView: BaseTableSectionHeaderView {

    let editButton = UIButton()
    let prjViewController:PrjViewController
    let category:CategoryCoreData
    let projectName:String
    let projectID:NSManagedObjectID
    var categoryDelegate:CategoryTableSectionHeaderViewProtocol?
    
    init(titleText: String, section: Int, expandable: Bool,prjViewController:PrjViewController,category:CategoryCoreData,projectName:String,projectID:NSManagedObjectID) {
        self.prjViewController = prjViewController
        self.category = category
        self.projectName = projectName
        self.projectID = projectID
        super.init(titleText: titleText, section: section, expandable: expandable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryTableSectionHeaderView {
    override func configureView() {
        super.configureView()
        
        addButton.isHidden = true
        editButton.setImage(UIImage(systemName: Resources.Images.edite,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        editButton.tintColor = .gray
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        self.addView(editButton)
        
        titleRightAnchorConstraint?.isActive = false
        titleRightAnchorConstraint = title.rightAnchor.constraint(lessThanOrEqualTo: editButton.leftAnchor, constant: -10)
        titleRightAnchorConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: editButton.imageView?.image?.size.width ?? 20),
            editButton.rightAnchor.constraint(equalTo: chevronImageView.leftAnchor, constant: -10),
        ])
    }
}


extension CategoryTableSectionHeaderView {
    @objc private func editButtonTapped(_ sender:UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Resources.Titles.addTask, style: .default, handler: {[weak self] _ in
            guard let self = self else {return}
            let createTaskViewController = CreateTaskRouter.createModule(category: self.category, section: self.section, projectName: self.projectName)
            createTaskViewController.projectID = self.projectID
            createTaskViewController.modalPresentationStyle = .overCurrentContext
            createTaskViewController.delegate = self.prjViewController
            self.prjViewController.present(createTaskViewController,animated: false)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.renameSection, style: .default, handler: { [weak self] _ in
            guard let category = self?.category else {return}
            self?.categoryDelegate?.renameSection(category: category)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.deleteSection, style: .destructive, handler: { [weak self] _ in
            guard let category = self?.category else {return}
            self?.categoryDelegate?.deleteSection(category: category)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
        prjViewController.present(alert,animated: true)
    }
}
