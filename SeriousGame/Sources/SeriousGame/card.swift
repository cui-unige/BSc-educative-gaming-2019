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
    
    func actionDechaine(objStack: Card, log: inout String) {
        if (objStack.jaugeStorm < 21) {
            objStack.jaugeStorm += 1
        }
        log += "\(color)2\(red)\n* The jauge is increased by 1 → [\(Int(objStack.jaugeStorm))]\(color)0\(none)\n"
    }
    
    func actionDechaineMel(objStack: Card, log: inout String) {
        if (objStack.jaugeStorm < 21) {
            objStack.jaugeStorm += 1
        }
        objStack.stormStack.shuffle()
        log += "\(color)2\(red)\n* The jauge is increased by 1 → [\(objStack.jaugeStorm)]\n * The stack of storm cards is shuffled\(color)0\(none)"
    }
    
    func actionEclair(currentDeadLine: inout Int, log: inout String) {
        currentDeadLine = currentDeadLine - 1
        log += "\(color)2\(red)\n* You lose 1 point of deadline → [\(currentDeadLine)]\(color)0\(none)"
    }
    
    func actionVentTourneHoraire(needle: inout String, log: inout String) {
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
        log += "\(color)2\(red)\n* The wind turn, now his direction is [\(needle)]\(color)0\(none)\n"
    }
    
    func actionVentTourneAntiHoraire(needle: inout String, log: inout String) {
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
        log += "\(color)2\(red)\n* The wind turn, now his direction is [\(needle)]\(color)0\(none)\n"
    }
    
    func actionBourasque(nbPlayer: Int, arrayPlayer: [Player], boardCase: [String], boardPos: inout [String], posPlayer: inout [Int], boardInstruction: [String], W: Int, H: Int, needle: String, deadline: inout Int, log: inout String) {
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
            log += "\(color)2\(red)\n* The direction of wind was [\(needle)]\(color)0\(none)"
            for currentPlayer in tmpArrayPlayer {
                let res = calculateAvailablePosBourasque(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, needle: needle, deadline: &deadline)
                if (res.0) {
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
                    currentPlayer.position = currentPlayer.position+1
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position] + String(currentPlayer.id+1) + " "
                    posPlayer[currentPlayer.id] = currentPlayer.position
                    log += "\(color)2\(red)\n* \(currentPlayer.nom) has been moved from \(currentPlayer.position-1) to \(currentPlayer.position)\(color)0\(none)"
                } else {
                    log += "\(color)2\(red)\n* \(currentPlayer.nom) fell, deadline is now [\(deadline)]\(color)0\(none)"
                }
                
            }
        case "↑":
            log += "\(color)2\(red)\n* The direction of wind was [\(needle)]\(color)0\(none)\n"
            for currentPlayer in tmpArrayPlayer {
                let res = calculateAvailablePosBourasque(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, needle: needle, deadline: &deadline)
                if (res.0) {
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
                    currentPlayer.position = currentPlayer.position-W
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position] + String(currentPlayer.id+1) + " "
                    posPlayer[currentPlayer.id] = currentPlayer.position
                    log += "\(color)2\(red)\n* \(currentPlayer.nom) has been moved from \(currentPlayer.position+W) to \(currentPlayer.position)\(color)0\(none)"
                } else {
                    log += "\(color)2\(red)\n* \(currentPlayer.nom) fell, deadline is now [\(deadline)]\(color)0\(none)"
                }
            }
        case "←":
            log += "\(color)2\(red)\n* The direction of wind was [\(needle)]\(color)0\(none)\n"
            for currentPlayer in tmpArrayPlayer {
                let res = calculateAvailablePosBourasque(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, needle: needle, deadline: &deadline)
                if (res.0) {
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
                    currentPlayer.position = currentPlayer.position-1
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position] + String(currentPlayer.id+1) + " "
                    posPlayer[currentPlayer.id] = currentPlayer.position
                    log += "\(color)2\(red)\n* \(currentPlayer.nom) has been moved from \(currentPlayer.position+1) to \(currentPlayer.position)\(color)0\(none)"
                } else {
                    log += "\(color)2\(red)\n* \(currentPlayer.nom) fell, deadline is now [\(deadline)]\(color)0\(none)"
                }
            }
        case "↓":
            log += "\(color)2\(red)\n* The direction of wind was [\(needle)]\(color)0\(none)\n"
            for currentPlayer in tmpArrayPlayer {
                let res = calculateAvailablePosBourasque(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, needle: needle, deadline: &deadline)
                if (res.0) {
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
                    currentPlayer.position = currentPlayer.position+W
                    boardPos[currentPlayer.position] = boardPos[currentPlayer.position] + String(currentPlayer.id+1) + " "
                    posPlayer[currentPlayer.id] = currentPlayer.position
                    log += "\(color)2\(red)\n* \(currentPlayer.nom) has been moved from \(currentPlayer.position-W) to \(currentPlayer.position)\(color)0\(none)"
                } else {
                    log += "\(color)2\(red)\n* \(currentPlayer.nom) fell, deadline is now [\(deadline)]\(color)0\(none)"
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
