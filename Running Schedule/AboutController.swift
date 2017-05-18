//
//  AboutController.swift
//  RunningSchedule
//
//  Created by Luís Machado on 22/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AboutController: UIViewController {
    
    lazy var aboutLabel: UITextView = {
        let label = UITextView()
        
        label.text = "This app allows you to find races being held in Portugal and enables you to learn specific information about each one."

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let pubView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.adUnitID = "ca-app-pub-9818298689423769/7822215135"
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "About"
        
        view.addSubview(aboutLabel)
        view.addSubview(pubView)
        
        pubView.rootViewController = self
        let request = GADRequest()
        request.testDevices = ["23f185209c128b138d6ced0fb4d7ef7f"]
        pubView.load(request)
        
        pubView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pubView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pubView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pubView.heightAnchor.constraint(equalToConstant: pubSize).isActive = true
        
        aboutLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        aboutLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        aboutLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        aboutLabel.bottomAnchor.constraint(equalTo: pubView.topAnchor, constant: -10).isActive = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            
           self.aboutLabel.frame = CGRect(x: 10, y: 10, width: size.width - 20, height: size.height - 30)
        }, completion: nil)
    }

}
