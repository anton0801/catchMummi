//
//  SetImageAsBackground.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import Foundation
import UIKit

extension UIView {
    func assignBackground(name: String) {
        let background = UIImage(named: name)
        var imageView : UIImageView!
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = self.center
        self.addSubview(imageView)
        self.sendSubviewToBack(imageView)
    }
}
