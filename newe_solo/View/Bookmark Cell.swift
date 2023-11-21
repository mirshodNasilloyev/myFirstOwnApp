import UIKit

final class BookmarkCell: UITableViewCell {
    
    //MARK: - Properties
                
    //MARK: - UI Components
    
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
    
    @objc func bookmarkButtonPressed(_ sender: UIButton) {}
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Configuration

    func setContent(with feed: Feed) {
        
        categoryLabel.text = feed.category
        countryLabel.text = feed.country
        titleLabel.text = feed.title
        
        bookmarkButton.setImage(UIImage(systemName: feed.isBookmarked ? "bookmark.fill" : "bookmark"), for: .normal)
    }
    
    func configureView() {
        backgroundColor = .clear
        
        constractHierarchy()
        activateConstraints()
        
    }
    
    private func constractHierarchy() {
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bookmarkButton)
        
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
            
        ])
        
        NSLayoutConstraint.activate([
            
            countryLabel.topAnchor.constraint(equalTo: categoryLabel.topAnchor),
            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
            
        ])
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12)
            
        ])
        
        NSLayoutConstraint.activate([
            
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            bookmarkButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -12),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30)
            
        ])
    }
}

