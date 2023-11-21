import UIKit
import Kingfisher

final class FeedCell: UITableViewCell {
    
    //MARK: - Properties

    private var feed: Feed?
        
    private let userDefaults = UserDefaultsManager.shared
                
    //MARK: - UI Components
    
    private let newsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(bookmarkButtonPressed(_ :)), for: .touchUpInside)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    @objc func bookmarkButtonPressed(_ sender: UIButton) {
        
        if bookmarkButton.currentImage == UIImage(systemName: "bookmark") {
            bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
    }
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Confguration
    
    func setContent(with feed: Feed) {
        
        titleLabel.text = feed.title
        categoryLabel.text = feed.category
        descriptionLabel.text = feed.description
        
        if let selectedCountry = userDefaults.getSelectedCountry(), selectedCountry.code == feed.country {
            
            countryLabel.isHidden = true
            
        } else {
            
            countryLabel.isHidden = false
            countryLabel.text = feed.country
            
            NSLayoutConstraint.activate([
                
                countryLabel.topAnchor.constraint(equalTo: categoryLabel.topAnchor),
                countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
                
            ])
            
        }
        
        if let imageUrl = feed.image,
           
           let url = URL(string: imageUrl) {
            
            newsImage.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil)
            
            NSLayoutConstraint.activate([
                
                newsImage.topAnchor.constraint(equalTo: contentView.topAnchor),
                newsImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                newsImage.heightAnchor.constraint(equalTo: newsImage.widthAnchor, multiplier: 0.6)
                
            ])
            
        } else {
            
            newsImage.image = nil
            
            NSLayoutConstraint.activate([
                
                newsImage.topAnchor.constraint(equalTo: contentView.topAnchor),
                newsImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                newsImage.heightAnchor.constraint(equalTo: newsImage.widthAnchor, multiplier: 0.01)
                
            ])
        }
    }
    
    private func configureView() {
        backgroundColor = .clear
        
        constractHierarchy()
        activateConstraints()
        
    }
    
    private func constractHierarchy() {
        
        contentView.addSubview(newsImage)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(descriptionLabel)
        
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            
            categoryLabel.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
            
        ])
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40)
            
        ])
        
        NSLayoutConstraint.activate([
            
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            bookmarkButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30)
            
        ])
        
        NSLayoutConstraint.activate([
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            
        ])
    }
}

