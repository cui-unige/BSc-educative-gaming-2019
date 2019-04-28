//
//  player.swift
//  SeriousGame
//
//  Created by cui on 22.04.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

class Player {
    var id: Int
    var nom: String
    var cartes: [String]
    var position: Int
    
    init(id: Int, nom: String, cartes: [String], position: Int) {
        self.id = id
        self.nom = nom
        self.cartes = cartes
        self.position = position
    }
}

