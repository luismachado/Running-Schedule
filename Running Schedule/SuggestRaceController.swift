//
//  SuggestRaceController.swift
//  RunPortugal
//
//  Created by Luís Machado on 24/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit
import Eureka

class SuggestRaceController: FormViewController {

    let spinner = UIActivityIndicatorView()
    var sendingButton: UIBarButtonItem?
    var sendButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Suggest Race"
        
        spinner.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        sendingButton = UIBarButtonItem(customView: spinner)
        sendButton = UIBarButtonItem(image: UIImage(named: "send"), style: .plain, target: self, action: #selector(handleSend))
        
        navigationItem.rightBarButtonItem = sendButton
        
        form +++ Section("")
            <<< TextRow(){ row in
                row.tag = "name"
                row.title = "Race Name"
                row.placeholder = "Insert name"
                row.add(rule: RuleRequired())
            }.cellUpdate { cell, row in
                if !row.isValid {
                    print(row.validationErrors)
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< DateRow(){
                $0.tag = "date"
                $0.title = "Date"
                $0.value = Date()
            }
            <<< TextRow(){ row in
                row.tag = "localization"
                row.title = "Location"
                row.placeholder = "Insert location"
            }
            <<< TextRow(){ row in
                row.tag = "observations"
                row.title = "Info"
                row.placeholder = "Insert info"
            }
            <<< EmailRow(){
                $0.tag = "email"
                $0.title = "E-Mail"
                $0.placeholder = "Insert email"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
            }.cellUpdate { cell, row in
                if !row.isValid {
                    print(row.validationErrors)
                    cell.titleLabel?.textColor = .red
                }
        }
    }

    func handleSend() {
        
        form.validate()
        
        guard let nameRow = form.rowBy(tag: "name") as? TextRow else { showEmailAlarm(); return }
        guard let dateRow = form.rowBy(tag: "date") as? DateRow else { showEmailAlarm(); return }
        guard let localizationRow = form.rowBy(tag: "localization") as? TextRow else { showEmailAlarm(); return }
        guard let observationsRow = form.rowBy(tag: "observations") as? TextRow else { showEmailAlarm(); return }
        guard let emailRow = form.rowBy(tag: "email") as? EmailRow else { showEmailAlarm(); return }
        
        if !nameRow.isValid {
            showEmailAlarm(message: "Race name has to be filled.")
            return
        }
        
        if !emailRow.isValid {
            showEmailAlarm(message: "Email has to be correctly filled.")
            return
        }
        
        guard let name = nameRow.value else { return }
        guard let email = emailRow.value else { return }
        
        let emailSender = EmailSender()
        
        navigationItem.rightBarButtonItem = sendingButton
        spinner.startAnimating()
        
        emailSender.sendEmail(name: name, date: dateRow.value, location: localizationRow.value, observations: observationsRow.value, contactEmail: email) { (error) in
        
            self.spinner.stopAnimating()
            self.navigationItem.rightBarButtonItem = self.sendButton
            
            if error != nil {
                self.showEmailAlarm()
            } else {
                self.showEmailAlarm(message: "Suggestion was sent succesfully")
                nameRow.value = nil
                dateRow.value = nil
                localizationRow.value = nil
                observationsRow.value = nil
                emailRow.value = nil
                self.tableView?.reloadData()
            }
        }
    }
    
    private func showEmailAlarm(message: String = "") {
        if message != "" {
            AlertHelper.displayAlert(title: "Send suggestion", message: message, displayTo: self)
        } else {
            AlertHelper.displayAlert(title: "Send suggestion", message: "Error sending suggestion. Please try again later.", displayTo: self)
        }
        
    }
}

