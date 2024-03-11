//
//  AppDelegate.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 27.02.2024.
//

import UIKit
import AVFAudio

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var audioPlayer: AVAudioPlayer?
    
    var backgroundSoundAudioPlayer: AVAudioPlayer? = {
        do {try AVAudioSession.sharedInstance().setCategory(.ambient,
                                                            mode: .default,
                                                            options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            
        }
        
        guard
            let backgroundSoundURL = Bundle.main.url(forResource: "background",
                                                     withExtension: "mp3"),
            let audioPlayer = try? AVAudioPlayer(contentsOf: backgroundSoundURL)
        else { return nil }
        
        audioPlayer.volume = 0.3
        audioPlayer.numberOfLoops = -1
        
        return audioPlayer
    }()
    
    public func stopMusic() {
        backgroundSoundAudioPlayer?.stop()
    }
    public func playMusic() {
        backgroundSoundAudioPlayer?.prepareToPlay()
        backgroundSoundAudioPlayer?.play()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

