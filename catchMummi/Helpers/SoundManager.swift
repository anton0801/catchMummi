//
//  SoundManager.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 29.02.2024.
//

import Foundation
import AVFoundation

enum SoundType: String {
    case wav
}

struct SoundManager {

    var player: AVAudioPlayer?

    mutating func setupPlayer(soundName: String, soundType: SoundType) {
        
        if let soundURL = Bundle.main.url(forResource: soundName,
                                          withExtension: soundType.rawValue) {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.prepareToPlay()
            }
            catch  {
            }
        }
    }
    
    func play(_ numberOfLoops: Int = 0) {
        player?.stop()
        player?.numberOfLoops = numberOfLoops
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.stop()
    }
    
    func volume(_ level: Float) {
        player?.volume = level
    }
}
