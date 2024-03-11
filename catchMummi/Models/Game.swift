//
//  Game.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import Foundation

enum Characer: String {
    case mummy = "Mummy"
    case anumbis = "Anubis"
    case pharaoh = "Pharaoh"
}

final class Game {
    var character: Characer
    
    init(character: Characer, hpNumber: Double = 10.0, time: Int = 10) {
        self.character = character
    }
    public static var shared: Game = Game(character: .mummy)
    
}
