//
//  card.swift
//  SeriousGame
//
//  Created by cui on 14.05.19.
//

import Foundation

class Card {
    var stormStack: [String] = []
    var equipStack: [String]
    
    init(stormStack: [String], equipStack: [String]) {
        self.stormStack = stormStack
        self.equipStack = equipStack
    }
}
