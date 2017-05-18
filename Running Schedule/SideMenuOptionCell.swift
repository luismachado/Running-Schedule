//
//  SideMenuOptionView.swift
//  RunPortugal
//
//  Created by Luís Machado on 22/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

enum SideMenuOptionType: String {
    case allRaces = "Races"
    case roadRaces = "Road"
    case trailRaces = "Trail"
    case otherRaces = "Other"
    case options = "Options"
    case suggestion = "Suggest Race"
    case about = "About"
}

class SideMenuOption: NSObject {
    let imageName: String
    let optionType: SideMenuOptionType
    
    init(imageName: String, optionType: SideMenuOptionType) {
        self.imageName = imageName
        self.optionType = optionType
    }
}

class SideMenuOptionCell: UICollectionViewCell {
    
    var sideMenuOption: SideMenuOption? {
        didSet {
            if let imageName = sideMenuOption?.imageName {
                nextImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                nextImageView.tintColor = .black
            }
            
            nextLabel.text = sideMenuOption?.optionType.rawValue
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            
            nextLabel.textColor = isHighlighted ? .white : .black
            
            nextImageView.tintColor = isHighlighted ? .white : .black
        }
    }

    let nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upperSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    private func setLayout() {
        addSubview(nextImageView)
        nextImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nextImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        nextImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        nextImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        addSubview(nextLabel)
        nextLabel.centerYAnchor.constraint(equalTo: nextImageView.centerYAnchor).isActive = true
        nextLabel.leftAnchor.constraint(equalTo: nextImageView.rightAnchor, constant: 28).isActive = true
        nextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        nextLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(upperSeparatorView)
        upperSeparatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        upperSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        upperSeparatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        upperSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(bottomSeparatorView)
        bottomSeparatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomSeparatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        upperSeparatorView.isHidden = true
        bottomSeparatorView.isHidden = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
