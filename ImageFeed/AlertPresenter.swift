//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Наиль on 07/10/23.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: ((UIAlertAction) -> Void)?
}

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    func showAlert(alertModel: AlertModel) {
        
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)
        alert.addAction(action)
        
        delegate?.present(alert, animated: true)
    }
}
