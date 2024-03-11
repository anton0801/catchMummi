//
//  Tutor.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import Foundation
import UIKit

class TutorialView: UIView {
    let label = UILabel()
    let continueButton = UIButton()
    var texts: [String] = [""] {
        didSet {
            if texts.count > cuttentPage {
                label.text = texts[cuttentPage]
            }
        }
    }
    var cuttentPage = 0 {
        didSet {
            if texts.count > cuttentPage {
                if texts.count == cuttentPage + 1 {
                    continueButton.setTitle("End",
                                            for: .normal)
                }
                label.text = texts[cuttentPage]
            }
            else {
                hideSelf()
            }
        }
    }
    
    func hideSelf() {
        label.isHidden = true
        continueButton.isHidden = true
        DefaultsManager().saveObject(false,
                                     for: .tutorial)
        self.isHidden = true
    }
    
    func config() {
        self.backgroundColor = .systemOrange.withAlphaComponent(0.95)
        label.text = texts[0]
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "Futura",
                            size: 18)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: self.widthAnchor,
                                     multiplier: 0.8).isActive = true
        label.heightAnchor.constraint(equalTo: self.heightAnchor,
                                      multiplier: 0.8).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        continueButton.setTitle("Continue",
                                for: .normal)
        self.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: -10).isActive = true
        continueButton.addTarget(self,
                                 action: #selector(nextPage),
                                 for: .touchUpInside)
    }
    
    func setTexts(_ texts: [String]) {
        self.texts = texts
    }
    
    @objc func nextPage() {
        cuttentPage += 1
    }
}

extension UIView {
    func addTutor(_ tutorialView: TutorialView) {
        self.addSubview(tutorialView)
        tutorialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tutorialView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     tutorialView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     tutorialView.widthAnchor.constraint(equalTo: self.widthAnchor),
                                     tutorialView.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                                          multiplier: 0.4)])
    }
}
