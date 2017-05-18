//
//  ViewController.swift
//  RunPortugal
//
//  Created by Luís Machado on 21/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit
import SideMenuController
import GoogleMobileAds

let pubSize:CGFloat = 50
//let pubSize:CGFloat = 0

class GeneralController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    var races = [Race]()
    var racesToDisplay = [Race]()
    var filteredRaces = [Race]()
    let userDefaults = UDWrapper()
    var searchOpen: Bool = false
    var windowSize: CGSize?
    var cellHeight: CGFloat?
    let noRaceFound: String = "No race found"
    
    lazy var searchView: SearchBarView = {        
        let view = SearchBarView(frame: CGRect(x: 0, y: -50, width: self.view.frame.size.width, height: 50))
        view.generalController = self
        view.backgroundColor = UIColor(red: 234/255, green: 0, blue: 0, alpha: 1)
        view.alpha = 1
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .darkGray
        ai.startAnimating()
        return ai
    }()
    
    lazy var noResultsLabel: UITextView = {
        let label = UITextView()
        label.text = self.noRaceFound
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isScrollEnabled = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    let pubView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.adUnitID = "ca-app-pub-9818298689423769/6345481939"
        return view
    }()
    
    var openSearchBarButton: UIBarButtonItem?
    var closeSearchBarButton: UIBarButtonItem?
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get rid of black bar underneath navbar
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 234/255, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = "Running Schedule"
        
        windowSize = UIScreen.main.bounds.size
        
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8 + pubSize, right: 8)
        collectionView?.register(RaceCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        view.addSubview(pubView)
        pubView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pubView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pubView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pubView.heightAnchor.constraint(equalToConstant: pubSize).isActive = true
        
        view.addSubview(noResultsLabel)
        noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultsLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        noResultsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        noResultsLabel.isHidden = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sidemenu"), style: .plain, target: self, action: #selector(openSideMenu))
        openSearchBarButton = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(handleToggleSearch))
        closeSearchBarButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(handleToggleSearch))
        
        navigationItem.rightBarButtonItem = openSearchBarButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.view.addSubview(searchView)
        
        pubView.rootViewController = self
        let request = GADRequest()
        request.testDevices = ["23f185209c128b138d6ced0fb4d7ef7f"]
        pubView.load(request)
        
        let attributes = [ NSForegroundColorAttributeName : UIColor(red: 234/255, green: 0, blue: 0, alpha: 1) ] as [String: Any]
        refreshControl.tintColor = UIColor(red: 234/255, green: 0, blue: 0, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing races...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }
        
        refreshData()
        
    }
    
    @objc private func refreshData() {
        ApiService.sharedInstance.fetchRaces { (races, error) in
            
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            
            if error != nil {
                self.errorWithFetch()
            } else {
                
                if let races = races {
                    self.races = races
                }
                self.filterRaces(filter: nil)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func openSideMenu() {
        dismissKeyboard()
        self.sideMenuController?.toggle()
    }
    
    func dismissKeyboard() {
        searchView.dismissKeyboard()
    }
    
    func errorWithFetch() {
        noResultsLabel.text = "Unable to obtain race list. Please try again later."
        noResultsLabel.isHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.transitionView(size: size)
        }, completion: nil)
    }
    
    func transitionView(size: CGSize) {
        windowSize = size
        searchView.frame = CGRect(x: searchView.frame.minX, y: searchView.frame.minY, width: size.width, height: searchView.frame.height)
        collectionView?.reloadData()
    }
    
    private func calcNumberOfCellsPerRow(frameSize: CGSize?) -> Int {
        
        guard let frameSize = frameSize else { return 2 }
        let isLandscape = frameSize.width > frameSize.height ? true : false        
        return isLandscape ? 3 : 2
    }
    
    private func calcWidthPerCell(frameSize:CGSize) -> CGFloat {
        
        var startingValue = CGFloat(calcNumberOfCellsPerRow(frameSize: frameSize))
        var spacing = 8.7 * (startingValue + 1.0)
        var width = ((frameSize.width - spacing) / startingValue) - 2
        
        while width > 250 {
            startingValue += 1
            spacing = 8.7 * (startingValue + 1.0)
            width = ((frameSize.width - spacing) / startingValue) - 2
        }
        
        return width
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return racesToDisplay.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RaceCell
        cell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        let race = racesToDisplay[indexPath.item]
        cell.race = race
        if let cellHeight = cellHeight {
            cell.posterImageViewHeightAnchor?.constant = cellHeight - 50.0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var width:CGFloat = 172 //default value for ios
        
        if let windowSize = windowSize {
            width = calcWidthPerCell(frameSize: windowSize)
            cellHeight = width * 1.74
        }
        
        return CGSize(width: width, height: cellHeight!)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let raceController = RaceController()
        raceController.race = racesToDisplay[indexPath.item]
        
        dismissKeyboard()
        navigationController?.pushViewController(raceController, animated: true)
    }

    
    func filterRaces(filter: raceType?) {
        
        if let filter = filter {
            racesToDisplay = [Race]()
            for race in races {
                if race.type == filter {
                    racesToDisplay.append(race)
                }
            }
            
        } else {
            racesToDisplay = races
        }
        
        filteredRaces = racesToDisplay
        
        if filteredRaces.count == 0 {
            noResultsLabel.isHidden = false
            noResultsLabel.text = noRaceFound
        } else {
            noResultsLabel.isHidden = true
        }
        
        collectionView?.reloadData()
        
    }
}




