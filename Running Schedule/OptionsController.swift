//
//  OptionsController.swift
//  RunningSchedule
//
//  Created by Luís Machado on 26/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class OptionsController: UITableViewController {
    
    let cellId = "cellId"
    var userDefaults: UDWrapper?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Definições"
        tableView.register(OptionsCell.self, forCellReuseIdentifier: cellId)

    }
    
    func valueChanged(value: Bool, option: OptionType) {
        
        if option == .notifications {
            userDefaults?.setBool(key: configKeys.notificationsKey, value: value)
        } else if option == .highResPhotos {
            userDefaults?.setBool(key: configKeys.highResKey, value: value)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OptionsCell
        
        if indexPath.row == 0 {
            cell.title.text = "Notificações"
            cell.detail.text = "Receber notificações de novas provas ou notícias"
            cell.optionType = OptionType.notifications
            if let notificationsEnabled = userDefaults?.getBool(key: configKeys.notificationsKey, defaultValue: configDefaults.notifications) {
                cell.switchButton.isOn = notificationsEnabled
            }
        } else {
            cell.title.text = "Visualização de imagens"
            cell.detail.text = "Visualização de cartazes das provas em máxima definição"
            cell.optionType = OptionType.highResPhotos
            if let highResEnabled = userDefaults?.getBool(key: configKeys.highResKey, defaultValue: configDefaults.highRes) {
                cell.switchButton.isOn = highResEnabled
            }
        }
        
        cell.optionsController = self
        cell.selectionStyle = .none
        
        return cell
        
    }
}

enum OptionType: String {
    case notifications = "notifications"
    case highResPhotos = "highResPhotos"
}

class OptionsCell: UITableViewCell {
    
    var optionsController: OptionsController?
    var optionType: OptionType?
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detail: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.addTarget(self, action: #selector(handleValueChanged), for: UIControlEvents.valueChanged)
        return sw
    }()
    
    func handleValueChanged() {
        if let optionsController = optionsController, let optionType = optionType {
            optionsController.valueChanged(value: switchButton.isOn, option: optionType)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(switchButton)
        switchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive = true
        switchButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 51).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 31).isActive = true
        
        addSubview(title)
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        title.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/3).isActive = true
        title.rightAnchor.constraint(equalTo: switchButton.leftAnchor, constant: -8).isActive = true
        
        addSubview(detail)
        detail.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        detail.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        detail.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2/3).isActive = true
        detail.rightAnchor.constraint(equalTo: switchButton.leftAnchor, constant: -8).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
