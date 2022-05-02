//
//  QTransactionAmmountCell.swift
//  Qoin
//
//  Created by Maksym S. on 01.05.2022.
//

import Foundation
import UIKit

protocol QTransactionAmmountCellProtocol where Self: UITableViewCell {
    var textField: UITextField { get }
}


class QTransactionAmmountCell: UITableViewCell, QTransactionAmmountCellProtocol {
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = UIKeyboardType.numberPad
        tf.returnKeyType = UIReturnKeyType.done
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.borderStyle = UITextField.BorderStyle.roundedRect
        tf.clearButtonMode = UITextField.ViewMode.whileEditing;
        tf.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tf
    }()
    
    fileprivate var firstStart = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !firstStart {
            addSubview(textField)
            
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        }
    }
}
