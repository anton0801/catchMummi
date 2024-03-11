//
//  FreeGameViewController.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import UIKit

class FreeGameViewController: UIViewController {
    @IBOutlet weak var levelLabel: UILabel!
    var tutorial = TutorialView()
    
    var hitSound = SoundManager()
    
    @IBOutlet weak var backButton: NSLayoutConstraint!
    @IBOutlet weak var characterHP: UILabel!
    var characterHpCount = 10.0 {
        didSet {
            characterHP.text = "\(Int(max(0.0, characterHpCount - hitnumber))) hp"
        }
    }
    @IBOutlet weak var characterHp: UIProgressView!
    private var hitnumber = 0.0 {
        didSet {
            characterHP.text = "\(Int(max(0.0, characterHpCount - hitnumber))) hp"
        }
    }
    private var totalHitNumber = 0.0 {
        didSet {
            timeLabel.text = "Hits: \(Int(totalHitNumber))"
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var boosterImage: UIImageView!
    
    var lastPoint: CGPoint = CGPoint(x: 0,
                                     y: 0)
    var counter = 0
    var time = Timer()
    var hideTimer = Timer()
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
        
        if DefaultsManager().fetchObject(type: Bool.self,
                                         for: .tutorial2) ?? true {
            view.addTutor(tutorial)
            tutorial.config()
            tutorial.setTexts(["Welcome to Curse of Anubis! This is the non stop mode of the game!",
                               "Your goal is to defeat enemies by clicking on their icons. Each click takes away 1 HP, and you need to remove all the HP",
                               "In this mode, there are no levels or time limits; you can endlessly defeat various enemies. The number of defeated enemies is tracked in the top right corner",
                               "Use boosters to make it easier – clicking on them takes away 3, 5, or 7 HP",
                               "Can you click strategically, beat the enemies, and complete each level? Let's see if you can win!"])
            DefaultsManager().saveObject(false,
                                         for: .tutorial2)
        }
       
        generateEnemy()
        
        let enemiesCount = DefaultsManager().fetchObject(type: Int.self,
                                                         for: .enemies)
        levelLabel.text = " Enemies: \(Int(enemiesCount ?? 0))  "
        levelLabel.layer.cornerRadius = 4
        levelLabel.clipsToBounds = true
        startingPosition = Int(CGFloat(characterImage.frame.origin.y))
        
        timeLabel.text = "Hits: \(Int(hitnumber))"
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.spawnRandomPosition), userInfo: nil, repeats: true)
        
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
    
    @objc func toMenu() {
        dismiss(animated: true)
    }
    
    @objc func replay() {
        let level = DefaultsManager().fetchObject(type: Int.self,
                                                  for: .level) ?? 1
        characterImage.isUserInteractionEnabled = true
        characterHp.progress = 1
        hitnumber = 0
        characterHpCount = Double(min(45,
                                      10 + 3 * level))
        characterHP.text = "\(Int(max(0.0, characterHpCount))) hp"
        
        levelLabel.text = "Lvl: \(level)  "
        
        hideTimer = Timer.scheduledTimer(timeInterval: max(0.3,
                                                           1 - Double(level) * 0.05),
                                         target: self,
                                         selector: #selector(self.spawnRandomPosition),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func onTouch2() {
        boosterImage.image = nil
        boosterImage.isUserInteractionEnabled = false
        hitnumber += boosterValue
        totalHitNumber += boosterValue
        characterHp.progress = Float((characterHpCount - hitnumber) / characterHpCount)
        if characterHp.progress == 0 {
            let enemiesCount = DefaultsManager().fetchObject(type: Int.self,
                                                             for: .enemies)
            DefaultsManager().saveObject((enemiesCount ?? 0) + 1,
                                         for: .enemies)
            let newEnemiesCount = DefaultsManager().fetchObject(type: Int.self,
                                                             for: .enemies)
            levelLabel.text = " Enemies: \(Int(newEnemiesCount ?? 1))  "
            generateEnemy()
        }
    }
    
    @objc func onTouch() {
        hitnumber += 1.0
        if DefaultsManager().fetchObject(type: Bool.self,
                                         for: .sounds) ?? true {
            hitSound.play()
        }
        totalHitNumber += 1.0
        characterHp.progress = Float((characterHpCount - hitnumber) / characterHpCount)
        if characterHp.progress == 0 {
            let enemiesCount = DefaultsManager().fetchObject(type: Int.self,
                                                             for: .enemies)
            DefaultsManager().saveObject((enemiesCount ?? 0) + 1,
                                         for: .enemies)
            let newEnemiesCount = DefaultsManager().fetchObject(type: Int.self,
                                                             for: .enemies)
            levelLabel.text = " Enemies: \(Int(newEnemiesCount ?? 1))  "
            generateEnemy()
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
    
    func generateEnemy() {
        hitnumber = 0
        characterHp.progress = 1
        let images = [UIImage(named: "mummi"),
                      UIImage(named: "anubis"),
                      UIImage(named: "pharaoh")
        ]
        let random = (DefaultsManager().fetchObject(type: Int.self,
                                                         for: .enemies) ?? 1) % 2
        characterImage.image = images[random]
        characterHpCount = Double(Int.random(in: 10...40))
    }
    
    @objc func spawnRandomPosition() {
        counter += 1
        spawnRandomBooster()
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
        if counter % 10 == 0 {
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
        else if counter % 10 != 1 {
            boosterImage.image = nil
            boosterImage.isUserInteractionEnabled = false
        }
     }
}
