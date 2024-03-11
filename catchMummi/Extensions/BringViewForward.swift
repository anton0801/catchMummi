//
//  BringViewForward.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import Foundation
import UIKit

extension UIView {
    func bringViewForward() {
        guard let index = self.superview?.subviews.firstIndex(of: self) else {
            return
        }
        
        let newIndex = min(index + 1, self.superview?.subviews.count ?? 0 - 1)
        
        self.superview?.exchangeSubview(at: index, withSubviewAt: newIndex)
    }
}
