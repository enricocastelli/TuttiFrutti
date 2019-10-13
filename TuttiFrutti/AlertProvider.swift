//
//  AlertProvider.swift
//  TuttiFrutti
//
//  Created by Enrico Castelli on 13/10/2019.
//  Copyright © 2019 EC. All rights reserved.
//

import UIKit

struct AlertModel {
    let title: String
    let description: String
    let buttonTitle: String
    let completion: ((UIAlertAction) -> Void)?
}

protocol AlertProvider {}

extension AlertProvider where Self: UIViewController {
    
    func presentAlert(_ model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.description, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonTitle, style: .default, handler: (model.completion ?? { (_) in
            alert.dismiss(animated: true, completion: nil)
            }))
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentGeneralErrorAlert() {
        let model = AlertModel(title: "OPS", description: "Something went wrong...", buttonTitle: "OK", completion: nil)
        let alert = UIAlertController(title: model.title, message: model.description, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonTitle, style: .default, handler: (model.completion ?? { (_) in
            alert.dismiss(animated: true, completion: nil)
            }))
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
