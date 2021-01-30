//
//  Settings.swift
//  Project
//
//  Created by Rainier Dotulong on 1/7/21.
//

import Foundation
import UIKit

extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.white.cgColor
    }
    func roundedImage2() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/4 //This will change with corners of image and height/2 will make this circle shape
        self.clipsToBounds = true
    }
}
extension UIButton {
    func roundedButton() {
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
    }
}
extension UIView {
    func roundedView() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
}

