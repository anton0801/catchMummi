//
//  MenuViewController.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import UIKit

class MenuViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var frameView: UIView!

    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var nonStopButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    var popUp: PopUp?
    var modePopUp: PopUp?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let level = DefaultsManager().fetchObject(type: Int.self,
                                                  for: .level) ?? 1
        levelLabel.text = "Lvl: \(level)  "
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
            return .portrait
        }
    
    func appearanceSetUp() {
        view.assignBackground(name: "background")
        let level = DefaultsManager().fetchObject(type: Int.self,
                                                  for: .level) ?? 1
        nonStopButton.layer.borderColor = UIColor.white.cgColor
        nonStopButton.layer.borderWidth = 3
        nonStopButton.layer.cornerRadius = 5
        nonStopButton.clipsToBounds = true
        nonStopButton.addTarget(self,
                                action: #selector(toFree),
                                for: .touchUpInside)
        
        levelLabel.text = "Lvl: \(level)  "
        levelLabel.layer.cornerRadius = 4
        levelLabel.clipsToBounds = true
        frameView.layer.cornerRadius = 15
        frameView.clipsToBounds = true
        settingsButton.addTarget(self,
                                 action: #selector(showSettings),
                                 for: .touchUpInside)
        startButton.addTarget(self,
                              action: #selector(startButtonAnimation),
                              for: .touchUpInside)
        if DefaultsManager().fetchObject(type: Bool.self,
                                         for: .music) ?? true {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.playMusic()
            }
        }
    }
    
    @objc func startButtonAnimation() {
        modePopUp = PopUp(mode: [])
        view.presentPopUp(popUp: modePopUp!)
        [modePopUp!.popUpButtonTop].forEach { button in
            button.addTarget(self,
                                                  action: #selector(presentMummi),
                                                  for: .touchUpInside)
        }
        modePopUp!.popUpMidBottom.addTarget(self,
                                            action: #selector(presentAlertAnubis),
                                            for: .touchUpInside)
        modePopUp!.popUpButtonBottom.addTarget(self,
                                            action: #selector(presentPharaoh),
                                            for: .touchUpInside)
    }
    
    @objc func presentMummi() {
        Game.shared.character = .mummy
        toMain()
    }
    
    @objc func presentAlertAnubis() {
        if (DefaultsManager().fetchObject(type: Int.self,
                                          for: .level) ?? 1) < 5 {
                let alert = UIAlertController(title: "This mode is locked :(",
                                              message: "It will be open on 5 level",
                                              preferredStyle: .alert)
                let alertDismiss = UIAlertAction(title: "Ok",
                                                 style: .cancel)

                alert.addAction(alertDismiss)
                self.present(alert,
                             animated: true)
            }
        else {
            Game.shared.character = .anumbis
            self.toMain()
        }
    }
    
    @objc func presentPharaoh() {
        if (DefaultsManager().fetchObject(type: Int.self,
                                          for: .level) ?? 1) < 8 {
                let alert = UIAlertController(title: "This mode is locked :(", message: "It will be open on 8 level",
                                              preferredStyle: .alert)
                let alertDismiss = UIAlertAction(title: "Ok",
                                                 style: .cancel)

                alert.addAction(alertDismiss)
                self.present(alert,
                             animated: true)
            }
        else {
            Game.shared.character = .pharaoh
            self.toMain()
        }
    }
    
    @objc func toMain() {
        modePopUp?.removeFromSuperview()
        self.performSegue(withIdentifier: "toGame",
                          sender: nil)
    }
    
    @objc func toFree() {
        self.performSegue(withIdentifier: "toFree",
                          sender: nil)
    }
    
    @objc func showSettings() {
        popUp = PopUp(music: nil)
        popUp!.popUpButtonBottom.addTarget(self,
                                           action: #selector(removePopUp),
                                           for: .touchUpInside)
        view.presentPopUp(popUp: popUp!)
    }
    
    @objc func removePopUp() {
        popUp?.removeFromSuperview()
    }
}

