import UIKit

class ProjectTableViewCell: BaseTableViewCell {
    
    let nameTitle = UILabel()
    let circleImageView = UIImageView()
    let countOfTasksLabel = UILabel()
    var project:ProjectCoreData?
}

extension ProjectTableViewCell {
    override func addViews() {
        contentView.addView(nameTitle)
        contentView.addView(circleImageView)
        contentView.addView(countOfTasksLabel)
    }
    
    override func configure() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        nameTitle.font = .systemFont(ofSize: 18)
        circleImageView.image = UIImage(systemName: Resources.Images.circleFill,withConfiguration: Resources.Configurations.largeConfiguration)
        countOfTasksLabel.textColor = .gray
        countOfTasksLabel.font = .systemFont(ofSize: 16)
        
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            circleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 20),
            nameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameTitle.leftAnchor.constraint(equalTo: circleImageView.rightAnchor,constant: 15),
            nameTitle.rightAnchor.constraint(equalTo: countOfTasksLabel.leftAnchor, constant: -10),
            countOfTasksLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countOfTasksLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10)
        ])
    }
}
