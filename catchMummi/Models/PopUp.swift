//
//  PopUp.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import Foundation
import UIKit

final class PopUp: UIView {
    
    public let popUpImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        return imageView
    }()
    
    public let popUpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Trebuchet MS Bold",
                            size: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public let popUpButtonTop: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    public let popUpMidBottom: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    public let popUpButtonBottom: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    public let popUpStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    public let musicLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Trebuchet MS Bold",
                            size: 16)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Music:"
        label.textAlignment = .center
        return label
    }()
    
    public let soundsLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Trebuchet MS Bold",
                            size: 16)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Sounds:"
        label.textAlignment = .center
        return label
    }()
    
    public let musicSwitch = {
        let swich = UISwitch()
        swich.onTintColor = .systemOrange
        return swich
    }()
    
    public let soundsSwitch = {
        let swich = UISwitch()
        swich.onTintColor = .systemOrange
        return swich
    }()
    
    init(labelText: String) {
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: 0,
                                 height: 0))
        baseLayout()
        popUpStack.addArrangedSubviews(popUpImageView,
                                       popUpLabel,
                                       popUpButtonTop,
                                       popUpButtonBottom)
        popUpImageView.image = UIImage(named: "win")
        popUpLabel.text = "\(labelText)"
        popUpButtonTop.setPrettyTitle(title: "To menu")
        popUpButtonBottom.setPrettyTitle(title: "Next level")
    }
    
    init(gameOverText: String) {
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: 0,
                                 height: 0))
        baseLayout()
        popUpStack.addArrangedSubviews(popUpImageView,
                                       popUpLabel,
                                       popUpButtonTop,
                                       popUpButtonBottom)
        popUpImageView.image = UIImage(named: "gameOver")
        popUpLabel.text = "\(gameOverText)"
        popUpButtonTop.setPrettyTitle(title: "To menu")
        popUpButtonBottom.setPrettyTitle(title: "Replay")
    }
    
    init(mode: [Characer]) {
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: 0,
                                 height: 0))
        popUpStack.distribution = .fillEqually
        popUpLabel.text = "Select enemy:"
        popUpStack.addArrangedSubviews(popUpLabel,
                                       popUpButtonTop,
                                       popUpMidBottom,
                                       popUpButtonBottom)
        
        popUpMidBottom.layer.opacity = (DefaultsManager().fetchObject(type: Int.self,
                                                                      for: .level) ?? 1 > 4) == true ? 1 : 0.5
        popUpButtonBottom.layer.opacity = (DefaultsManager().fetchObject(type: Int.self,
                                                                         for: .level) ?? 1 > 7) == true ? 1 : 0.5
        popUpButtonTop.setPrettyTitle(title: Characer.mummy.rawValue)
        popUpMidBottom.setPrettyTitle(title: Characer.anumbis.rawValue)
        popUpButtonBottom.setPrettyTitle(title: Characer.pharaoh.rawValue)
        baseLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func modeButtonFunc(button: UIButton) {
        switch button {
        case popUpButtonTop:
            Game.shared.character = .mummy
        case popUpMidBottom:
            Game.shared.character = .anumbis
            
        default:
            Game.shared.character = .pharaoh
        }
    }
    
    init(music: String?) {
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: 0,
                                 height: 0))
        baseLayout()
        let text = "Settings:"
        self.addSubview(popUpLabel)
        
        popUpLabel.text = text
        popUpLabel.translatesAutoresizingMaskIntoConstraints = false
        popUpLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                        constant: 10).isActive = true
        popUpLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        popUpLabel.widthAnchor.constraint(equalTo: self.widthAnchor,
                                          multiplier: 0.8).isActive = true
        popUpLabel.heightAnchor.constraint(equalTo: self.heightAnchor,
                                           multiplier: 0.3).isActive = true
        
        self.addSubview(popUpButtonBottom)
        popUpButtonBottom.translatesAutoresizingMaskIntoConstraints = false
        popUpButtonBottom.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        popUpButtonBottom.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                  constant: -20).isActive = true
        popUpButtonBottom.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                  multiplier: 0.15).isActive = true
        popUpButtonBottom.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                 multiplier: 0.8).isActive = true
        popUpButtonBottom.setPrettyTitle(title: "Back")
        
        self.addSubview(musicLabel)
        musicLabel.translatesAutoresizingMaskIntoConstraints = false
        musicLabel.leadingAnchor.constraint(equalTo: popUpButtonBottom.leadingAnchor).isActive = true
        musicLabel.topAnchor.constraint(equalTo: popUpLabel.bottomAnchor,
                                        constant: 10).isActive = true
        
        self.addSubview(musicSwitch)
        musicSwitch.isOn = DefaultsManager().fetchObject(type: Bool.self,
                                                         for: .music) ?? true
        musicSwitch.translatesAutoresizingMaskIntoConstraints = false
        musicSwitch.leadingAnchor.constraint(equalTo: musicLabel.trailingAnchor,
                                             constant: 10).isActive = true
        musicSwitch.centerYAnchor.constraint(equalTo: musicLabel.centerYAnchor).isActive = true
        musicSwitch.addTarget(self,
                              action: #selector(checkMusic),
                              for: .valueChanged)
        
        self.addSubview(soundsSwitch)
        soundsSwitch.isOn = DefaultsManager().fetchObject(type: Bool.self,
                                                          for: .sounds) ?? true
        soundsSwitch.translatesAutoresizingMaskIntoConstraints = false
        soundsSwitch.trailingAnchor.constraint(equalTo: popUpButtonBottom.trailingAnchor).isActive = true
        soundsSwitch.centerYAnchor.constraint(equalTo: musicLabel.centerYAnchor).isActive = true
        soundsSwitch.addTarget(self,
                               action: #selector(checkSounds),
                               for: .valueChanged)
        
        self.addSubview(soundsLabel)
        soundsLabel.translatesAutoresizingMaskIntoConstraints = false
        soundsLabel.trailingAnchor.constraint(equalTo: soundsSwitch.leadingAnchor,
                                              constant: -10).isActive = true
        soundsLabel.centerYAnchor.constraint(equalTo: musicLabel.centerYAnchor).isActive = true
    }
    
    private func baseLayout() {
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.systemOrange.cgColor
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.addSubview(popUpStack)
        popUpStack.translatesAutoresizingMaskIntoConstraints = false
        popUpStack.topAnchor.constraint(equalTo: self.topAnchor,
                                        constant: 20).isActive = true
        popUpStack.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                           constant: -20).isActive = true
        popUpStack.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                            constant: 20).isActive = true
        popUpStack.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                             constant: -20).isActive = true
    }
    
    @objc func checkMusic() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if musicSwitch.isOn {
                appDelegate.playMusic()
                DefaultsManager().saveObject(true,
                                             for: .music)
            }
            else {
                appDelegate.stopMusic()
                DefaultsManager().saveObject(false,
                                             for: .music)
            }
        }
    }
    
    @objc func checkSounds() {
        if soundsSwitch.isOn {
            DefaultsManager().saveObject(true,
                                         for: .sounds)
        }
        else {
            DefaultsManager().saveObject(false,
                                         for: .sounds)
        }
    }
}

extension UIView {
    func presentPopUp(popUp: PopUp) {
        self.addSubview(popUp)
        let centerConstraint = popUp.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        centerConstraint.isActive = true
        popUp.layer.shadowColor = UIColor.black.cgColor
        popUp.layer.shadowRadius = 80
        popUp.layer.shadowOpacity = 0.3
        popUp.layer.shadowOffset = CGSize(width: 0, height: 0)
        popUp.clipsToBounds = true
        popUp.translatesAutoresizingMaskIntoConstraints = false
        popUp.widthAnchor.constraint(equalTo: self.widthAnchor,
                                     multiplier: 0.9).isActive = true
        popUp.heightAnchor.constraint(equalTo: self.widthAnchor,
                                      multiplier: 0.8).isActive = true
        popUp.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.layoutIfNeeded()
    }
}
