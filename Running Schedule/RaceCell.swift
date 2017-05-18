//
//  RaceCell.swift
//  RunPortugal
//
//  Created by Luís Machado on 23/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class RaceCell: UICollectionViewCell {
    
    var race: Race? {
        didSet {
            nameLabel.text = race?.name
            
            if let date = race?.date {
                self.dateLabel.text = date
            }
            
            posterImageView.image = nil
            
            if let imageUrl = race?.posterUrl {
                posterImageView.loadImageUsingUrlString(urlString: imageUrl)
            }
            
        }
    }
    
    let posterImageView: RaceImageView = {
        let imageView = RaceImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "calendar_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "2a Meia Maratona de Lisboa"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Novembro, 27"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var posterImageViewHeightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(posterImageView)
        posterImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        posterImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        posterImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        posterImageViewHeightAnchor = posterImageView.heightAnchor.constraint(equalToConstant: 250)
        posterImageViewHeightAnchor?.isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 4).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(calendarImageView)
        calendarImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        calendarImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        calendarImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        calendarImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        addSubview(dateLabel)
        dateLabel.centerYAnchor.constraint(equalTo: calendarImageView.centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: calendarImageView.rightAnchor, constant: 6).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
