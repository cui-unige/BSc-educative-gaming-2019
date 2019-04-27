//
//  player.swift
//  SeriousGame
//
//  Created by cui on 22.04.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

class Player {
    var nom: String
    var cartes: [String]
    var position: String
    
    init(nom: String, cartes: [String], position: String) {
        self.nom = nom
        self.cartes = cartes
        self.position = position
    }
}

