//
//  card.swift
//  SeriousGame
//
//  Created by cui on 14.05.19.
//

import Foundation

class Card {
    var stormStack: [String]
    var equipStack: [String]
    var jaugeStorm: Double
    
    init(stormStack: [String], equipStack: [String], jaugeStorm: Double) {
        self.stormStack = stormStack
        self.equipStack = equipStack
        self.jaugeStorm = jaugeStorm
    }
    
    func actionDechaine(objStack: Card) {
        if (objStack.jaugeStorm < 21) {
            objStack.jaugeStorm += 1
        }
    }
    
    func actionDechaineMel(objStack: Card) {
        if (objStack.jaugeStorm < 21) {
            objStack.jaugeStorm += 1
        }
        objStack.stormStack.shuffle()
    }
    
    func actionEclair(currentDeadLine: inout Int) {
        currentDeadLine = currentDeadLine - 1
    }
    
    func actionVentTourneHoraire(needle: inout String) {
        switch needle {
        case "→":
            needle = "↓"
        case "↓":
            needle = "←"
        case "←":
            needle = "↑"
        case "↑":
            needle = "→"
        default:
            needle = "→"
        }
    }
    
    func actionVentTourneAntiHoraire(needle: inout String) {
        switch needle {
        case "→":
            needle = "↑"
        case "↑":
            needle = "←"
        case "←":
            needle = "↓"
        case "↓":
            needle = "→"
        default:
            needle = "→"
        }
    }
    
    func actionBourasque(nbPlayer: Int, arrayPlayer: [Player], boardCase: [String], boardPos: inout [String], posPlayer: inout [Int], boardInstruction: [String], W: Int, needle: String) {
        print("boardCase: ", boardCase)
        print("boardPos: ", boardPos)
        print("posPlayer: ", posPlayer)
        print("boardInstruction: ", boardInstruction)
        let tmpArrayPlayer = arrayPlayer.prefix(nbPlayer)
        print("tmpArrayPlayer:", tmpArrayPlayer)
        
        switch needle {
        case "→":
            for currentPlayer in tmpArrayPlayer {
                boardPos[currentPlayer.position] = boardPos[currentPlayer.position].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
                currentPlayer.position = currentPlayer.position+1
                boardPos[currentPlayer.position] = boardPos[currentPlayer.position] + String(currentPlayer.id+1) + " "
                posPlayer[currentPlayer.id] = currentPlayer.position
            }
        case "↑":
            for player in 0...posPlayer.count-1 {
                posPlayer[player] -= W
                //boardPos[currentPlayer.position] = String(currentPlayer.position-W)
            }
        case "←":
            for player in 0...posPlayer.count-1 {
                posPlayer[player] -= 1
                //boardPos[currentPlayer.position] = String(currentPlayer.position-1)
            }
        case "↓":
            for player in 0...posPlayer.count-1 {
                posPlayer[player] += W
                //boardPos[currentPlayer.position] = String(currentPlayer.position+W)
            }
        default:
            for player in 0...posPlayer.count-1 {
                //posPlayer[player] = posPlayer[player]
            }
        }
    }
}
