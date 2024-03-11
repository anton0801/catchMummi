//
//  TouchAnimation.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func animateTouch(at point: CGPoint,
                        color: UIColor) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let ballHitView = UIView()
        ballHitView.backgroundColor = color

        view.addSubview(ballHitView)
        view.sendSubviewToBack(ballHitView)
        ballHitView.bringViewForward()
        ballHitView.frame = CGRect(
            origin: CGPoint(
                x: point.x,
                y: point.y
            ),
            size: CGSize(width: 10,
                         height: 10)
        )
        ballHitView.layer.cornerRadius = 5
        ballHitView.alpha = 1

        let scale: CGFloat = 10 * .random(in: 1.5...3.5)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                ballHitView.alpha = 0
                ballHitView.transform = CGAffineTransform(scaleX: scale, y: scale)
            },
            completion: { _ in
                ballHitView.removeFromSuperview()
            }
        )
    }
}
