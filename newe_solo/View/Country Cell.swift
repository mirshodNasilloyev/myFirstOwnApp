import UIKit

final class CountryCell: UITableViewCell {
    
    //MARK: - UI Components
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    private let flag: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Confguration
    
    func setContent(with country: Country) {
        nameLabel.text = country.name
        flag.image = UIImage(named: country.flag)
    }
    
    private func configureView() {
        backgroundColor = .clear
        constractHierarchy()
        activateConstraints()
    }
    
    private func constractHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(flag)
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: flag.leadingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            
        ])
        
        NSLayoutConstraint.activate([
            
            flag.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            flag.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            flag.widthAnchor.constraint(equalToConstant: 60),
            flag.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}


