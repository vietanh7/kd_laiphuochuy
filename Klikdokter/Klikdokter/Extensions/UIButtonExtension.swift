//
//  UIButtonExtension.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//


import UIKit

extension UIButton {
    func setEnabled(_ isEnabled: Bool) {
        self.isUserInteractionEnabled = isEnabled
        self.alpha = isEnabled ? 1.0 : 0.3
    }
}
