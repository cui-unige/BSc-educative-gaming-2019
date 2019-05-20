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
    
    func actionBourasque(nbPlayer: Int, arrayPlayer: [Player], boardCase: [String], boardPos: inout [String], posPlayer: inout [Int], boardInstruction: [String], W: Int, H: Int, needle: String, deadline: inout Int) {
        /*
        print("boardCase: ", boardCase)
        print("boardPos: ", boardPos)
        print("posPlayer: ", posPlayer)
        print("boardInstruction: ", boardInstruction)
         */
        let tmpArrayPlayer = arrayPlayer.prefix(nbPlayer)
        //print("tmpArrayPlayer:", tmpArrayPlayer)
        
        switch needle {
        case "→":
            // move every player if conditions are checked
            for currentPlayer in tmpArrayPlayer {
                let res = calculateAvailablePosBourasque(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, needle: needle, deadline: &deadline)
                if (res.0) {
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
                    currentPlayer.position = currentPlayer.position+1
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position] + String(currentPlayer.id+1) + " "
                    posPlayer[currentPlayer.id] = currentPlayer.position
                }
            }
        case "↑":
            for currentPlayer in tmpArrayPlayer {
                let res = calculateAvailablePosBourasque(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, needle: needle, deadline: &deadline)
                if (res.0) {
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
                    currentPlayer.position = currentPlayer.position-W
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position] + String(currentPlayer.id+1) + " "
                    posPlayer[currentPlayer.id] = currentPlayer.position
                }
            }
        case "←":
            for currentPlayer in tmpArrayPlayer {
                let res = calculateAvailablePosBourasque(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, needle: needle, deadline: &deadline)
                if (res.0) {
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
                    currentPlayer.position = currentPlayer.position-1
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position] + String(currentPlayer.id+1) + " "
                    posPlayer[currentPlayer.id] = currentPlayer.position
                }
            }
        case "↓":
            for currentPlayer in tmpArrayPlayer {
                let res = calculateAvailablePosBourasque(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, needle: needle, deadline: &deadline)
                if (res.0) {
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
                    currentPlayer.position = currentPlayer.position+W
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position] + String(currentPlayer.id+1) + " "
                    posPlayer[currentPlayer.id] = currentPlayer.position
                }
            }
        default:
            print("ERROR DEV")
        }
    }
    
    
    func calculateAvailablePosBourasque(currentPlayer: Player, boardInstr: [String], H: Int, W: Int, needle: String, deadline: inout Int) -> (Bool, Int) {
        var leftside: [Int] = []
        var rightside: [Int] = []
        // don't move but lose hp
        var posModified: Bool = false
        
        if (needle == "↑") {
            // testing edge
            if (0...W ~= currentPlayer.position) {
                deadline -= 1
            }
            // testing instr on case
            else if (boardInstr[currentPlayer.position-W] == "") {
                deadline -= 1
            }
            // else bourasque changed pos of player
            else {
                posModified = true
            }
        }
        
        if (needle == "↓") {
            if ((H*W)-W...(H*W)-1 ~= currentPlayer.position) {
                deadline -= 1
            } else if (boardInstr[currentPlayer.position+W] == "") {
                deadline -= 1
            } else {
                posModified = true
            }
        }
            
        for i in 0...H-1 {
            leftside.append(i*W)
            rightside.append(((i+1)*W)-1)
        }
        
        if (needle == "←") {
            if (leftside.contains(currentPlayer.position)) {
                deadline -= 1
            } else if (boardInstr[currentPlayer.position-1] == "") {
                deadline -= 1
            } else {
                posModified = true
            }
        }
        if (needle == "→") {
            if (rightside.contains(currentPlayer.position)) {
                deadline -= 1
            }
            else if (boardInstr[currentPlayer.position+1] == "") {
                deadline -= 1
            } else {
                posModified = true
            }
        }
        return (posModified, deadline)
    }
}
