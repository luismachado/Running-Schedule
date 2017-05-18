//
//  SideMenuController.swift
//  RunningSchedule
//
//  Created by Luís Machado on 21/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    weak var racesViewController: GeneralController?
    
    let cellHeight: CGFloat = 64
    let cellId = "cellId"
    let options: [SideMenuOption] = {
        return [
            SideMenuOption(imageName: "home", optionType: .allRaces),
            SideMenuOption(imageName: "road", optionType: .roadRaces),
            SideMenuOption(imageName: "trail", optionType: .trailRaces),
            SideMenuOption(imageName: "running", optionType: .otherRaces),
            SideMenuOption(imageName: "add", optionType: .suggestion),
            //SideMenuOption(imageName: "cog", optionType: .options),
            SideMenuOption(imageName: "info", optionType: .about)
        ]
    }()
    
    let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "banner")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return cv
    }()
    
    var bannerHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SideMenuOptionCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(bannerImageView)
        bannerImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        bannerImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        bannerImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        bannerHeightAnchor = bannerImageView.heightAnchor.constraint(equalToConstant: 80)
        bannerHeightAnchor?.isActive = true
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 24).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SideMenuOptionCell
        let option = options[indexPath.item]
        cell.sideMenuOption = option
        
        cell.upperSeparatorView.isHidden = !(option.optionType == .suggestion)
        cell.bottomSeparatorView.isHidden = !(option.optionType == .suggestion)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.view.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let option = options[indexPath.item]
        racesViewController?.handleOptionSelected(optionType: option.optionType)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var height: Double = 90.0
        
        if let image = bannerImageView.image {
            let ratio = image.size.height / image.size.width
            let imgWidth = bannerImageView.frame.width
            
            height = Double(ratio) * Double(imgWidth)
        }
        
        bannerHeightAnchor?.constant = CGFloat(height)
    }

}
