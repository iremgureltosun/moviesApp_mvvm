//
//  BaseViewController.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation

import Foundation
import UIKit

class CustomBackButtonNavController: UINavigationController { }

class BaseViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]

        if let _ = navigationController?.navigationBar {
            let labelWidth = (navigationController?.navigationBar.bounds.width)! - 110
            let label = UILabel(frame: CGRect(x: ((navigationController?.navigationBar.bounds.width)! / 2) - (labelWidth / 2), y: 0, width: labelWidth, height: (navigationController?.navigationBar.bounds.height)!))
            label.backgroundColor = .clear
            label.numberOfLines = 2
            label.font = UIFont.boldSystemFont(ofSize: 14.0)
            label.textAlignment = .center
            label.textColor = .black
            label.lineBreakMode = .byWordWrapping
            navigationController?.navigationBar.topItem?.title = nil
            navigationController?.navigationBar.addSubview(label)
        }

        let backButtonBackgroundImage = UIImage(systemName: "back-item")
        let barAppearance =
            UINavigationBar.appearance(whenContainedInInstancesOf: [CustomBackButtonNavController.self])
        barAppearance.backIndicatorImage = backButtonBackgroundImage
        barAppearance.backIndicatorTransitionMaskImage = backButtonBackgroundImage

        // Nudge the back UIBarButtonItem image down a bit.
        let barButtonAppearance =
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [CustomBackButtonNavController.self])
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -5), for: .default)

        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButton
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
