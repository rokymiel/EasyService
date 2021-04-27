//
//  UINavigationExtension.swift
//  EasyService
//
//  Created by Михаил on 24.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

extension UIViewController {
    func addCloseItem() {
        let image = UIImage(systemName: "xmark.circle.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(closeView))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
       
    }
    @objc func closeView() {
        dismiss(animated: true)
    }
}

// MARK: - Animate with keyboard
extension UIViewController {
    func animateWithKeyboard(
        notification: NSNotification,
        animations: ((_ keyboardFrame: CGRect) -> Void)?) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        if let duration = notification.userInfo![durationKey] as? Double,
            let keyboardFrameValue = notification.userInfo![frameKey] as? NSValue,
            let curveValue = notification.userInfo![curveKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveValue) {
            
            let animator = UIViewPropertyAnimator( duration: duration, curve: curve) {
                animations?(keyboardFrameValue.cgRectValue)
                self.view?.layoutIfNeeded()
                
            }
            animator.startAnimation()
        }
        
    }
}

extension UIViewController {
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
}
