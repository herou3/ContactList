//
//  ContactDetailView.swift
//  Contact List

import SnapKit

class ContactImageView: UIView {
    
    // MARK: - Init ContactDetailView
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Create UI elements
    private var contactImageView: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Portrait_placeholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.contactImageSize / 4
        return imageView
    }()
    
    private let helpsInstructionLabel: UILabel = {
        var instructionLabel: UILabel = UILabel()
        instructionLabel.text = "Choose photo"
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.textColor = .slategray
        instructionLabel.font = UIFont.systemFont(ofSize: 16)
        return instructionLabel
    }()
    
    // MARK: - Configure WeatherDetailView
    private func addContactImageView() {
        addSubview(contactImageView)
        contactImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Constant.marginLeftAndRightValue)
            make.left.equalTo(self.snp.centerX).offset(-Constant.contactImageSize / 4)
            make.right.equalTo(self.snp.centerX).offset(Constant.contactImageSize / 4)
            make.height.equalTo(Constant.contactImageSize / 2)
        }
    }
    
    private func addHelpsInstructionLabel() {
        addSubview(helpsInstructionLabel)
        helpsInstructionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contactImageView.snp.centerX)
            make.top.equalTo(contactImageView.snp.bottom).offset(Constant.marginLeftAndRightValue / 2)
            make.height.equalTo(Constant.marginLeftAndRightValue)
        }
    }
    
    private func setupViews() {
        addContactImageView()
        addHelpsInstructionLabel()
    }
    
    // MARK: - Method for update imageView
    func updateImage(image: UIImage?) {
        if image == nil {
            contactImageView.image = #imageLiteral(resourceName: "Portrait_placeholder")
        } else {
            contactImageView.image = image
        }
    }
}
