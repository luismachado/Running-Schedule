//
//  SearchBarView.swift
//  RunPortugal
//
//  Created by Luís Machado on 29/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class SearchBarView: UIView, UITextFieldDelegate {
    
    var generalController: GeneralController?
    
    lazy var inputTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Search..."
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 3
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        return textField
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cancelButton)
        cancelButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: cancelButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: heightAnchor, constant: -16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissKeyboard() {
        inputTextField.resignFirstResponder()
    }
    
    func handleSearch() {
        dismissKeyboard()
        generalController?.handleSearch(searchTerm: inputTextField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

}

class CustomTextField : UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
