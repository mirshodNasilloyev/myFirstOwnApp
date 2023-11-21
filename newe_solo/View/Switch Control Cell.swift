import UIKit

final class SwitchControlCell: UITableViewCell {
    
    //MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark mode"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    private let switchControl: UISwitch = {
        let control = UISwitch()
        control.isOn = true
        control.tintColor = UIColor.red
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        
        let switchState = sender.isOn
        UserDefaultsManager.shared.saveSwitchState(switchState)
        
    }
    
    //MARK: - Init
       
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    //MARK: - View Configuration
       
    private func configureView() {
        backgroundColor = .clear
        
        constractHierarchy()
        activateConstraints()
        
    }
    
    private func constractHierarchy() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchControl)
        
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            
        ])
            
        NSLayoutConstraint.activate([
            
            switchControl.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            
        ])
    }
}


