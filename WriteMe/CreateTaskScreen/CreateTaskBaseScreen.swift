import UIKit
import CoreData

class CreateTaskBaseController:BottomSheetController {
    private lazy var mainLabel = UILabel()
    lazy var descriptionTextView = UITextView()
    var nameTextField = UITextField()
    var createTaskButton = UIButton()
    let dateTextField = UITextField()
    var timeTextField = UITextField()
    let horizontStackView = UIStackView()
    let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = .current
        return formatter
    }()
    let timeFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = .current
        return formatter
    }()
    var date:Date? {
        willSet {
            if newValue == nil {
                self.disableTextField(textField: timeTextField)
            }
        }
    }
    var timeDate:Date?
    let projectButton = UIButton()
    var projectID:NSManagedObjectID?
    
    private enum UIConstants {
        static let mainLabelFont = 24.0
        static let descriptionTextViewFont = 15.0
        static let viewCornerRadius = 40.0
        static let mainLabelTopAnchor = 10.0
        static let nameTextFieldTopAnchor = 15.0
        static let nameTextFieldHeight = 35.0
        static let nameTextFieldLeftAnchor = 5.0
        static let nameTextFieldRightAnchor = -5.0
        static let descriptionTextFieldTopAnchor = 10.0
        static let descriptionTextFieldLeftAnchor = 5.0
        static let descriptionTextFieldRightAnchor = -5.0
        static let descriptionHeightAnchor = 100.0
        static let createTaskButtonTopAnchor = 20.0
        static let projectButtonWidth = 100.0
    }
}

//MARK: - Setup view
extension CreateTaskBaseController {
    override func addViews() {
        super.addViews()
        containerView.addView(mainLabel)
        containerView.addView(descriptionTextView)
        containerView.addView(nameTextField)
        self.view.addView(horizontStackView)
    }
    
    override func configure() {
        super.configure()
        
        mainLabel.text = Resources.Titles.bottomSheetMainLabel
        mainLabel.font = .systemFont(ofSize: UIConstants.mainLabelFont)
        mainLabel.textColor = .systemOrange
        
        descriptionTextView.text = Resources.Placeholders.textViewPlaceholder
        descriptionTextView.textColor = UIColor.placeholderText
        descriptionTextView.font = .systemFont(ofSize: UIConstants.descriptionTextViewFont)
        descriptionTextView.delegate = self

        nameTextField.placeholder = Resources.Placeholders.textFieldPlaceholder
        nameTextField.delegate = self
        
        createTaskButton.setImage(UIImage(systemName: Resources.Images.createTaskButtonImage,withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .black, scale: .large)), for: .normal)
//        createTaskButton.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        self.disableCreateTaskButton()
        
        projectButton.layer.cornerRadius = 10
        projectButton.layer.borderColor = UIColor.gray.cgColor
        projectButton.layer.borderWidth = 1
        projectButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        projectButton.addTarget(self, action: #selector(projectButtonTapped(_:)), for: .touchUpInside)
        
        dateTextField.text = Resources.Titles.setDate
        dateTextField.adjustsFontSizeToFitWidth = true
        dateTextField.textColor = .link
        dateTextField.tintColor = .clear //to remove cursor when tapped
        
        let dateToolBar = createToolBar()

        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let clearDateButton: UIBarButtonItem = UIBarButtonItem(title: Resources.Titles.deleteDate, style: .done, target: self, action: #selector(clearDateButtonTapped(_:)))

        let doneDateButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneDateButtonTapped(_:)))
        
        dateToolBar.items = [flexsibleSpace,clearDateButton, doneDateButton]
        dateTextField.inputAccessoryView = dateToolBar
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar.current
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        let timeToolBar = createToolBar()
        
        let clearTimeButton: UIBarButtonItem = UIBarButtonItem(title: Resources.Titles.deleteDate, style: .done, target: self, action: #selector(clearTimeButtonTapped(_:)))

        let doneTimeButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneTimeButtonTapped(_:)))
        
        timeToolBar.items = [flexsibleSpace,clearTimeButton,doneTimeButton]
        timeTextField.inputAccessoryView = timeToolBar
        timeTextField.adjustsFontSizeToFitWidth = true
        self.disableTextField(textField: timeTextField)
        timeTextField.tintColor = .clear
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.calendar = Calendar.current
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        timeTextField.inputView = timePicker
        
        horizontStackView.axis = .horizontal
        horizontStackView.alignment = .fill
        horizontStackView.spacing = 1.5
        horizontStackView.distribution = .equalCentering
        horizontStackView.addArrangedSubview(projectButton)
        horizontStackView.addArrangedSubview(dateTextField)
        horizontStackView.addArrangedSubview(timeTextField)
        horizontStackView.addArrangedSubview(createTaskButton)
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: UIConstants.mainLabelTopAnchor),
            nameTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor,constant: UIConstants.nameTextFieldTopAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: UIConstants.nameTextFieldHeight),
            nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: UIConstants.nameTextFieldRightAnchor),
            nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: UIConstants.nameTextFieldLeftAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: UIConstants.descriptionTextFieldTopAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: UIConstants.descriptionTextFieldRightAnchor),
            descriptionTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: UIConstants.descriptionTextFieldLeftAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: UIConstants.descriptionHeightAnchor),
            horizontStackView.leftAnchor.constraint(equalTo: descriptionTextView.leftAnchor),
            horizontStackView.rightAnchor.constraint(equalTo: descriptionTextView.rightAnchor),
            horizontStackView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10)
        ])
    }
}

extension CreateTaskBaseController {
    
    func enableCreateTaskButton() {
        createTaskButton.tintColor = .systemOrange
        createTaskButton.isEnabled = true
    }
    
    private func disableCreateTaskButton() {
        createTaskButton.tintColor = .gray
        createTaskButton.isEnabled = false
    }
    
    private func disableTextField(textField:UITextField) {
        textField.text = Resources.Titles.setTime
        textField.isEnabled = false
        textField.textColor = .gray
    }
}

extension CreateTaskBaseController {
    
    @objc private func projectButtonTapped(_ sender:UIButton) {
        let popOverViewController = ProjectsPopOverViewController()
        popOverViewController.modalPresentationStyle = .popover
        popOverViewController.delegate = self
        
        guard let presentationViewController = popOverViewController.popoverPresentationController else {return}
        presentationViewController.delegate = self
        presentationViewController.sourceView = projectButton
        presentationViewController.permittedArrowDirections = .down
        presentationViewController.sourceRect = CGRect(x: projectButton.bounds.midX, y: projectButton.bounds.minY - 5, width: 0, height: 0)
        presentationViewController.passthroughViews = [projectButton]
        self.present(popOverViewController, animated: true, completion: nil)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        self.dateTextField.text = dateFormatter.string(from: sender.date)
        self.date = sender.date
        timeTextField.isEnabled = true
        timeTextField.textColor = .link
    }
    
    @objc private func timeChanged(_ sender: UIDatePicker) {
        self.timeTextField.text = timeFormatter.string(from: sender.date)
        self.timeDate = sender.date
    }
    
    @objc private func doneDateButtonTapped(_ sender:UIButton) {
        dateTextField.resignFirstResponder()
    }
    
    @objc private func clearDateButtonTapped(_ sender:UIButton) {
        self.date = nil
        self.dateTextField.text = Resources.Titles.setDate
        dateTextField.resignFirstResponder()
    }
    
    @objc private func doneTimeButtonTapped(_ sender:UIButton) {
        timeTextField.resignFirstResponder()
    }
    
    @objc private func clearTimeButtonTapped(_ sender:UIButton) {
        self.timeDate = nil
        self.timeTextField.text = Resources.Titles.setTime
        timeTextField.resignFirstResponder()
    }
    
}

//MARK: - UITextViewDelegate
extension CreateTaskBaseController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Resources.Placeholders.textViewPlaceholder
            textView.textColor = UIColor.placeholderText
        }
    }
}

//MARK: - UITextFieldDelegate
extension CreateTaskBaseController:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.isEmpty != true && text != " " else {
            self.disableCreateTaskButton()
            return
        }
        if projectID != nil {
            self.enableCreateTaskButton()
        }
    }
}

//MARK: - PopoverPresentation
extension CreateTaskBaseController:UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        true
    }
    
}

//MARK: - ProjectsPopOverDelegate
extension CreateTaskBaseController:ProjectsPopOverViewControllerProtocol {
    func passTappedProject(id: NSManagedObjectID, name: String) {
        self.projectButton.setTitle(name, for: .normal)
        self.projectID = id
        if let text = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty {
            self.enableCreateTaskButton()
        }
    }
}
