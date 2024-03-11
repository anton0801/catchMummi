//
//  ViewController.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 27.02.2024.
//

import UIKit

class GameViewController: UIViewController {
    // popUps
    var gameOverpopUp: PopUp?
    var winPopUp: PopUp?
    
    var hitSound  = SoundManager()
    
    @IBOutlet weak var levelLabel: UILabel!
    var tutorial = TutorialView()
    
    @IBOutlet weak var backButton: NSLayoutConstraint!
    @IBOutlet weak var characterHP: UILabel!
    var characterHpCount = 10.0
    @IBOutlet weak var characterHp: UIProgressView!
    private var hitnumber = 0.0 {
        didSet {
            characterHP.text = "\(Int(max(0.0, characterHpCount - hitnumber))) hp"
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var boosterImage: UIImageView!
    
    var lastPoint: CGPoint = CGPoint(x: 0,
                                     y: 0)
    
    var time = Timer()
    var hideTimer = Timer()
    var counter = 0 {
        didSet {
            timeLabel.text = "Time lefted: \(counter)"
        }
    }
    var boosterValue = 3.0
    var startingPosition = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setUp() {
        view.assignBackground(name: "background")
        
        hitSound.setupPlayer(soundName: "hitSound",
                             soundType: .wav)
        
        switch Game.shared.character {
        case .anumbis: characterImage.image = UIImage(named: "anubis")
        case .pharaoh: characterImage.image = UIImage(named: "pharaoh")
        case .mummy:
            characterImage.image = UIImage(named: "mummi")
        }
        
        let level = DefaultsManager().fetchObject(type: Int.self,
                                                  for: .level) ?? 1
        counter = max(10,
                      30 - level * 5)
        if DefaultsManager().fetchObject(type: Bool.self,
                                         for: .tutorial) ?? true {
            counter += 100
            view.addTutor(tutorial)
            tutorial.config()
            tutorial.setTexts(["Welcome to Curse of Anubis! This is the main screen of the game!",
                               "Your goal is to defeat enemies by clicking on their icons. Each click takes away 1 HP, and you need to remove all the HP within a time limit to move to the next level",
                               "Use boosters to make it easier – clicking on them takes away 3, 5, or 7 HP",
                               "Can you click strategically, beat the enemies, and complete each level? Let's see if you can win!"])
            DefaultsManager().saveObject(false,
                                         for: .tutorial)
        }
        characterHpCount = Double(min(50,
                                      10 + 3 * (level - 1)))
        characterHP.text = "\(Int(max(0.0, characterHpCount))) hp"
        
        levelLabel.text = "Lvl: \(level)  "
        levelLabel.layer.cornerRadius = 4
        levelLabel.clipsToBounds = true
        startingPosition = Int(CGFloat(characterImage.frame.origin.y))
        
        timeLabel.text = "Time lefted: \(counter)"
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), 
                                    userInfo: nil,
                                    repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: max(0.3,
                                                           1 - Double(level) * 0.05),
                                         target: self,
                                         selector: #selector(self.spawnRandomPosition),
                                         userInfo: nil,
                                         repeats: true)
        
        characterImage.isUserInteractionEnabled = true
        let characterTouched = UITapGestureRecognizer(target: self, action: #selector(onTouch))
        boosterImage.isUserInteractionEnabled = true
        let boosterTouched = UITapGestureRecognizer(target: self, action: #selector(onTouch2))
        boosterImage.addGestureRecognizer(boosterTouched)
        characterImage.addGestureRecognizer(characterTouched)
    }
    
    private func setUpCharacter() {
        characterHp.layer.cornerRadius = 3
        characterHp.clipsToBounds = true
    }

    @objc func startTimer() {
        spawnRandomBooster2()
        spawnRandomBooster()
        timeLabel.text = "Time lefted: \(counter)"
        counter -= 1
        if counter == 0 {
            if characterHp.progress != 0 {
                characterImage.isUserInteractionEnabled = false
                gameOverpopUp = PopUp(gameOverText: "Your time is over! Do you want to play again?")
                gameOverpopUp?.popUpButtonTop.addTarget(self,
                                                        action: #selector(toMenu), 
                                                        for: .touchUpInside)
                gameOverpopUp?.popUpButtonBottom.addTarget(self,
                                                           action: #selector(replay), 
                                                           for: .touchUpInside)
                view.presentPopUp(popUp: gameOverpopUp!)
                time.invalidate()
                hideTimer.invalidate()
                timeLabel.text = "Time is over!"
            }
        }
    }
    
    @objc func toMenu() {
        dismiss(animated: true)
        gameOverpopUp?.removeFromSuperview()
    }
    
    @objc func replay() {
        let level = DefaultsManager().fetchObject(type: Int.self,
                                                  for: .level) ?? 1
        characterImage.isUserInteractionEnabled = true
        counter = max(15,
                      30 - level * 5)
        characterHp.progress = 1
        hitnumber = 0
        characterHpCount = Double(min(45, 
                                      10 + 3 * level))
        timeLabel.text = "Time lefted \(self.counter)"
        characterHP.text = "\(Int(max(0.0, characterHpCount))) hp"
        
        levelLabel.text = "Lvl: \(level)  "
        
        time = Timer.scheduledTimer(timeInterval: 1,
                                    target: self, selector: #selector(self.startTimer),
                                    userInfo: nil,
                                    repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: max(0.3,
                                                           1 - Double(level) * 0.05),
                                         target: self,
                                         selector: #selector(self.spawnRandomPosition),
                                         userInfo: nil,
                                         repeats: true)
        gameOverpopUp?.removeFromSuperview()
        winPopUp?.removeFromSuperview()
    }
    
    @objc func onTouch2() {
        boosterImage.image = nil
        boosterImage.isUserInteractionEnabled = false
        if boosterValue == 3.1 || boosterValue == 5.1 {
            counter += Int(boosterValue)
        }
        else {
            hitnumber += boosterValue
            characterHp.progress = Float((characterHpCount - hitnumber) / characterHpCount)
            if characterHp.progress == 0 {
                characterImage.isUserInteractionEnabled = false
                let level = DefaultsManager().fetchObject(type: Int.self,
                                                          for: .level) ?? 1
                winPopUp = PopUp(labelText: "Congrats! You complete level \(level)!")
                DefaultsManager().saveObject(level + 1,
                                             for: .level)
                
                winPopUp?.popUpButtonTop.addTarget(self,
                                                   action: #selector(toMenu), for: .touchUpInside)
                winPopUp?.popUpButtonBottom.addTarget(self,
                                                      action: #selector(replay), for: .touchUpInside)
                view.presentPopUp(popUp: winPopUp!)
                time.invalidate()
                hideTimer.invalidate()
            }
        }
    }
    
    @objc func onTouch() {
        hitnumber += 1.0
        if DefaultsManager().fetchObject(type: Bool.self,
                                         for: .sounds) ?? true {
            hitSound.play()
        }
        characterHp.progress = Float((characterHpCount - hitnumber) / characterHpCount)
        if characterHp.progress == 0 {
            let level = DefaultsManager().fetchObject(type: Int.self,
                                                      for: .level) ?? 1
            winPopUp = PopUp(labelText: "Congrats! You complete level \(level)!")
            DefaultsManager().saveObject(level + 1,
                                         for: .level)
           
            winPopUp?.popUpButtonTop.addTarget(self,
                                                        action: #selector(toMenu),
                                               for: .touchUpInside)
            winPopUp?.popUpButtonBottom.addTarget(self,
                                                           action: #selector(replay),
                                                  for: .touchUpInside)
                view.presentPopUp(popUp: winPopUp!)
            characterImage.isUserInteractionEnabled = false
                time.invalidate()
                hideTimer.invalidate()
            
        }
        let bounds = characterImage.bounds
        var shrinkSize = CGRect(x: lastPoint.x,
                                y: lastPoint.y,
                                width: bounds.size.width + 25,
                                height: bounds.size.height + 25)
        
        animateTouch(at: lastPoint,
                     color: .systemOrange)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 5,
                       options: .curveLinear,
                       animations: { self.characterImage.bounds = shrinkSize},
                       completion: { _ in
            shrinkSize = CGRect(x: self.lastPoint.x,
                                y: self.lastPoint.y,
                                    width: bounds.size.width,
                                    height: bounds.size.height)
            UIView.animate(withDuration: 0.05,
                           delay: 0.0,
                           usingSpringWithDamping: 0.1,
                           initialSpringVelocity: 5,
                           options: .curveLinear,
                           animations: { self.characterImage.bounds = shrinkSize},
                           completion: nil )
        })
    }
    
    @objc func spawnRandomPosition() {
        let image = characterImage
        let imageWidth = image!.frame.width
        let imageHeight = image!.frame.height

        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height * 0.55

        let xwidth = viewWidth - imageWidth
        let yheight = viewHeight - imageHeight

        let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
        let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))

        image!.center.x = xoffset + imageWidth / 2
        image!.center.y = yoffset + CGFloat(startingPosition) + viewHeight / 2
        
        lastPoint = CGPoint(x: xoffset + imageWidth / 2,
                            y: yoffset + CGFloat(startingPosition) + viewHeight / 2)
     }
    
    func spawnRandomBooster() {
        let image = boosterImage
        if counter % 5 != 3 {
            boosterImage.image = nil
            boosterImage.isUserInteractionEnabled = false
        }
        if counter % 5 == 0 {
            let Images = [UIImage(named: "minusThree"), 
                          UIImage(named: "minusFive"),
                          UIImage(named: "minusSeven")]
            let random = Int.random(in: 0...2)
            boosterImage.isUserInteractionEnabled = true
            boosterImage.image = Images[random]
            
            switch random {
            case 0: boosterValue = 3.0
            case 1: boosterValue = 5.0
            default: boosterValue = 7.0
            }
            
            let imageWidth = image!.frame.width
            let imageHeight = image!.frame.height
            
            let viewWidth = UIScreen.main.bounds.width
            let viewHeight = UIScreen.main.bounds.height * 0.55
            
            let xwidth = viewWidth - imageWidth
            let yheight = viewHeight - imageHeight
            
            let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
            let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))
            
            image!.center.x = xoffset + imageWidth / 2
            image!.center.y = yoffset + viewHeight / 2
            
            lastPoint = CGPoint(x: xoffset + imageWidth / 2,
                                y: yoffset + viewHeight / 2)
        }
     }
    
    func spawnRandomBooster2() {
        let image = boosterImage
        boosterImage.image = nil
        boosterImage.isUserInteractionEnabled = false
        if counter % 5 == 3 {
            let Images = [UIImage(named: "timer3"),
                          UIImage(named: "timer5")]
            let random = Int.random(in: 0...1)
            boosterImage.isUserInteractionEnabled = true
            boosterImage.image = Images[random]
            
            switch random {
            case 0: boosterValue = 3.1
            case 1: boosterValue = 5.1
            default:
                return
            }
            
            let imageWidth = image!.frame.width
            let imageHeight = image!.frame.height
            
            let viewWidth = UIScreen.main.bounds.width
            let viewHeight = UIScreen.main.bounds.height * 0.55
            
            let xwidth = viewWidth - imageWidth
            let yheight = viewHeight - imageHeight
            
            let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
            let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))
            
            image!.center.x = xoffset + imageWidth / 2
            image!.center.y = yoffset + viewHeight / 2
            
            lastPoint = CGPoint(x: xoffset + imageWidth / 2,
                                y: yoffset + viewHeight / 2)
        }
     }
}

