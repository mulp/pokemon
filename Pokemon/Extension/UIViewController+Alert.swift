//
//  UIViewController+Alert.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import UIKit

extension UIViewController {
    func showError(error: Error) {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                                message: NSLocalizedString("An error as occurred \(error.localizedDescription)", comment: ""),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alertController, animated: true)
    }
}
