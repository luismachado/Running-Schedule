//
//  RaceController.swift
//  RunningSchedule
//
//  Created by Luís Machado on 21/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit
import EventKit
import GoogleMobileAds

class RaceController: UIViewController, UIScrollViewDelegate {

    let defaultPosterHeight: Double = 400
    
    var race: Race? {
        didSet {
            navigationItem.title = race?.name
            
            if let date = race?.date {
                calendarLabel.text = date
            }
            
            posterImageView.image = nil
            
            if let imageUrl = race?.posterUrl {
                posterImageView.loadImageUsingUrlString(urlString: imageUrl)
                updatePosterImageSizeFor(frameSize: view.frame.size)
            }
            
            if let distances = race?.distances {
                let distancesHeight = estimateFrameForText(text: distances).height
                if distancesHeight > 20 {
                    lengthLabelHeightAnchor?.constant = distancesHeight
                }
                lengthLabel.text = distances
            }
            
//            if let typeName = race?.typeName {
//                typeLabel.text = typeName
//            }
            
            if let type = race?.type {
                typeLabel.text = type.rawValue
            }
            
            if let location = race?.locationName, location != "" {
                let locationHeight = estimateFrameForText(text: location).height
                if locationHeight > 20 {
                    locationLabelHeightAnchor?.constant = locationHeight
                }
                locationLabel.text = location
            }
            
            if race?.webpage == nil {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
            
            containerView.backgroundColor = UIColor.clear
            scrollView.backgroundColor = .white
            setupContainerFor(frameSize: view.frame.size)
        }
    }
    
    private func setupContainerFor(frameSize: CGSize) {
        if let posterImageHeightAnchor = posterImageHeightAnchor, let lengthLabelHeightAnchor = lengthLabelHeightAnchor, let locationLabelHeightAnchor = locationLabelHeightAnchor {
            let containerHeight: CGFloat = CGFloat(posterImageHeightAnchor.constant + lengthLabelHeightAnchor.constant + locationLabelHeightAnchor.constant +  88.0 + pubSize)  // height + height of the other items + pubHeight
            
            scrollView.contentSize.width = frameSize.width
            scrollView.contentSize.height = containerHeight
        }
    }
    
    private func updatePosterImageSizeFor(frameSize: CGSize) {
        var height = defaultPosterHeight
        posterImageWidthAnchor?.constant = calcPosterMargins(size: frameSize)
        
        if let image = posterImageView.image {
            let ratio = image.size.height / image.size.width

            if let constant = posterImageWidthAnchor?.constant {
                let imgWidth = frameSize.width + constant
                height = Double(ratio) * Double(imgWidth)
            }
        }
        
        posterImageHeightAnchor?.constant = CGFloat(height)
        
    }
    
    private func calcPosterMargins(size: CGSize) -> CGFloat {
        
        var margins:CGFloat = -16
        
        if size.width > 450 + 16 {
            margins = 450 - size.width
        }

        return margins
        
    }
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    
    let posterImageView: RaceImageView = {
        let imageView = RaceImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "road")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let lengthImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "running")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "calendar_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "location")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "---"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lengthLabel: UITextView = {
        let label = UITextView()
        label.text = "---"
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        label.contentInset = UIEdgeInsets(top: -8, left: -6, bottom: 0, right: -6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let calendarLabel: UILabel = {
        let label = UILabel()
        label.text = "---"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UITextView = {
        let label = UITextView()
        label.text = "---"
        label.font = UIFont.systemFont(ofSize: 16)
        label.isUserInteractionEnabled = false
        label.backgroundColor = .clear
        label.contentInset = UIEdgeInsets(top: -8, left: -6, bottom: 0, right: -6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pubView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.adUnitID = "ca-app-pub-9818298689423769/7822215135"
        return view
    }()
    
    var containerViewWidth: NSLayoutConstraint?
    var posterImageHeightAnchor: NSLayoutConstraint?
    var posterImageWidthAnchor: NSLayoutConstraint?
    var lengthLabelHeightAnchor: NSLayoutConstraint?
    var locationLabelHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(handleMoreOptions))
    }
    
    func handleShare() {
        
        if let raceName = race?.name, let urlString = self.race?.webpage, let url = URL(string: urlString) {

            let activityViewController = UIActivityViewController(activityItems: ["Running Schedule", raceName, url], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func setView() {
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
        self.scrollView.backgroundColor = .white
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        containerViewWidth = containerView.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width)
        containerViewWidth?.isActive = true
        containerView.heightAnchor.constraint(equalToConstant: scrollView.contentSize.height).isActive = true
        
        containerView.addSubview(posterImageView)
        posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        posterImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        posterImageWidthAnchor = posterImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -16)
        posterImageWidthAnchor?.isActive = true
        posterImageHeightAnchor = posterImageView.heightAnchor.constraint(equalToConstant: 400)
        posterImageHeightAnchor?.isActive = true
        
        containerView.addSubview(typeImageView)
        typeImageView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8).isActive = true
        typeImageView.leftAnchor.constraint(equalTo: posterImageView.leftAnchor, constant: 8).isActive = true
        typeImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        typeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(typeLabel)
        typeLabel.topAnchor.constraint(equalTo: typeImageView.topAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: typeImageView.rightAnchor, constant: 8).isActive = true
        typeLabel.rightAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 8).isActive = true
        typeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(lengthImageView)
        lengthImageView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8).isActive = true
        lengthImageView.leftAnchor.constraint(equalTo: posterImageView.leftAnchor, constant: 8).isActive = true
        lengthImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        lengthImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(lengthLabel)
        lengthLabel.topAnchor.constraint(equalTo: lengthImageView.topAnchor).isActive = true
        lengthLabel.leftAnchor.constraint(equalTo: lengthImageView.rightAnchor, constant: 8).isActive = true
        lengthLabel.rightAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: -8).isActive = true
        lengthLabelHeightAnchor = lengthLabel.heightAnchor.constraint(equalToConstant: 20)
        lengthLabelHeightAnchor?.isActive = true
        
        containerView.addSubview(calendarImageView)
        calendarImageView.topAnchor.constraint(equalTo: lengthLabel.bottomAnchor, constant: 8).isActive = true
        calendarImageView.leftAnchor.constraint(equalTo: posterImageView.leftAnchor, constant: 8).isActive = true
        calendarImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        calendarImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(calendarLabel)
        calendarLabel.topAnchor.constraint(equalTo: calendarImageView.topAnchor).isActive = true
        calendarLabel.leftAnchor.constraint(equalTo: calendarImageView.rightAnchor, constant: 8).isActive = true
        calendarLabel.rightAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: -8).isActive = true
        calendarLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(locationImageView)
        locationImageView.topAnchor.constraint(equalTo: calendarLabel.bottomAnchor, constant: 8).isActive = true
        locationImageView.leftAnchor.constraint(equalTo: posterImageView.leftAnchor, constant: 8).isActive = true
        locationImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        locationImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: locationImageView.topAnchor).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: locationImageView.rightAnchor, constant: 8).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: -8).isActive = true
        locationLabelHeightAnchor = locationLabel.heightAnchor.constraint(equalToConstant: 20)
        locationLabelHeightAnchor?.isActive = true
        
        view.addSubview(pubView)
        pubView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pubView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pubView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pubView.heightAnchor.constraint(equalToConstant: pubSize).isActive = true
        
        pubView.rootViewController = self
        let request = GADRequest()
        request.testDevices = ["23f185209c128b138d6ced0fb4d7ef7f"]
        pubView.load(request)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updatePosterImageSizeFor(frameSize: size)
        setupContainerFor(frameSize: size)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        var width = view.frame.width - 140 // 140 is total width and spacing of rest of components
        if let margins = posterImageWidthAnchor?.constant {
            let imageWidth = self.view.frame.width + margins
            let extraPadding:CGFloat = 10.0
            let normalPadding:CGFloat = 8.0 + 20.0 + 8.0 + 8.0
            width = imageWidth - (normalPadding + extraPadding)
        }
        
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerViewWidth?.constant = view.bounds.width
    }
    
    func handleMoreOptions() {
        let optionMenu = UIAlertController(title: nil, message: "Actions", preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share" , style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.handleShare()
        })
        
        let websiteAction = UIAlertAction(title: "Go to website" , style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if let urlString = self.race?.webpage {
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        websiteAction.isEnabled = race?.webpage != nil
        
        let calendarAction = UIAlertAction(title: "Add to calendar", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.addEventToCalendar()
        })
        
        calendarAction.isEnabled = race?.date != nil
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        optionMenu.addAction(shareAction)
        optionMenu.addAction(websiteAction)
        optionMenu.addAction(calendarAction)
        optionMenu.addAction(cancelAction)
        
        optionMenu.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    @objc private func addEventToCalendar() {
        let eventStore : EKEventStore = EKEventStore()
        
        if let raceName = race?.name, let raceDate = race?.date {
            eventStore.requestAccess(to: .event) { (granted, error) in
                
                if (granted) && (error == nil) {
                    
                    let event:EKEvent = EKEvent(eventStore: eventStore)
                    
                    event.title = raceName
                    event.location = self.race?.locationName
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy MMMM, dd HH:mm zzz"
                    
                    let year = Calendar.current.component(.year, from: Date())
                    if let date = dateFormatter.date(from: "\(year) \(raceDate) 09:00 GMT") {
                        event.startDate = date
                        event.endDate = date
                        event.isAllDay = true
                        event.notes = self.lengthLabel.text
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        do {
                            try eventStore.save(event, span: .thisEvent)
                        } catch let error as NSError {
                            self.showCalendarError()
                            print(error)
                        }
                        AlertHelper.displayAlert(title: "Add to calendar", message: "Race added succesfully", displayTo: self)
                    } else {
                        self.showCalendarError()
                    }
                } else {
                    self.showCalendarError()
                }
            }
        } else {
            showCalendarError()
        }
    }
    
    private func showCalendarError() {
        AlertHelper.displayAlert(title: "Add to calendar", message: "Unable to add race to calendar. Please try again later.", displayTo: self)
    }

}
