//
//  PrettyButtonTitle.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import Foundation
import UIKit

extension UIButton {
    func setPrettyTitle(title: String) {
        self.setAttributedTitle(NSAttributedString(string: title,
                                                     attributes: [NSAttributedString.Key.font : UIFont(name: "Futura Bold",
                                                                                                       size: 19)!]),
                                  for: .normal)
    }
}
