//
//  board.swift
//  SeriousGame
//
//  Created by cui on 22.04.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

class Board {
    
    func lineBoard(n: Int) {
        for _ in 1...n {
            print("+----------------", terminator: "");
        }
        puts("+");
    }

    func lineCompl(n: Int, action: String) {
        if (action == "NOJUMP") {
            for _ in 1...1 {
                puts("|");
                for _ in 1...n {
                    print("|                ", terminator: "");
                }
            }
        } else {
            for _ in 1...3 {
                puts("|")
                for _ in 1...n {
                    print("|                ", terminator: "");
                }
            }
        }
        puts("|")
    }
    
    func linePlayer(n: Int) {
        puts("|")
        for _ in 1...n {
            print("|              ", terminator: "");
            puts("ok")
        }
    }
    
    func displayNumCase(n: Int, displayCase: inout [String], tmp: inout Int) {
        for _ in 0...n-1 {
            displayCase[tmp] = String(tmp)
            spaceWide(array: &displayCase, index: &tmp)
            tmp += 1
        }
    }
    
    // display starting pos of players
    func displayPosBegin(n: Int,  displayPos: inout [String], currentPosPlayer: inout [Int], tmp: inout Int) {
        for _ in 0...n-1 {
            for p in 0...currentPosPlayer.count-1 {
                if (currentPosPlayer[p] == tmp) {
                    displayPos[tmp] = String(p+1) + " "
                }
            }
            spaceWide(array: &displayPos, index: &tmp)
            tmp += 1
        }
    }
    
    // display the position of the players during the game
    func displayPosPlayer(n: Int,  displayPos: inout [String], currentPosPlayer: inout [Int], tmp: inout Int) {
        for _ in 0...n-1 {
            spaceWide(array: &displayPos, index: &tmp)
            tmp += 1
        }
    }
    
    // currentPosPlayer = tab des instr appened
    func displayInstructionPlayer(n: Int,  displayInstr: inout [String], currentInstrPlayer: inout [String], tmp: inout Int) {
        for _ in 0...n-1 {
            spaceWide(array: &displayInstr, index: &tmp)
            tmp += 1
        }
    }
    
    // complete empty space to dislay every types of board
    func spaceWide(array: inout [String], index: inout Int) {
        let size = array[index].count
        if (size <= 15) {
            let s = String(repeating: " ", count: 15-size)
            print("|"+s, array[index], terminator: "")
        } else {
            print("ERROR DEV")
        }
    }

    func displayBoard(boardInit: inout [String], displayPos: inout [String], displayInstruction: inout [String], H: Int, W: Int, posPlayer: inout [Int], instrPlayer: inout [String], bd: inout Bool) -> ([String], [String], [Int], Int, Int, [String], [String]) {
        var tmp = 0
        var tmp2 = 0
        var tmp3 = 0
        var boardTmp = boardInit
        var boardPosTmp = displayPos
        var boardInstructionTmp = displayInstruction
        var posPlayerTmp = posPlayer
        var instrPlayerTmp = instrPlayer
        for _ in 0...((boardInit.count)/W)-1 {
            lineBoard(n: W)
            displayNumCase(n: W, displayCase: &boardTmp, tmp: &tmp)
            lineCompl(n: W, action: "NOJUMP")
            displayInstructionPlayer(n: W,  displayInstr: &boardInstructionTmp, currentInstrPlayer: &instrPlayerTmp, tmp: &tmp3)
            lineCompl(n: W, action: "NOJUMP")
            if (bd) {
                displayPosBegin(n: W, displayPos: &boardPosTmp, currentPosPlayer: &posPlayerTmp, tmp: &tmp2)
            } else {
                displayPosPlayer(n: W,  displayPos: &boardPosTmp, currentPosPlayer: &posPlayerTmp, tmp: &tmp2)
            }
            puts("|")
        }
        lineBoard(n: W)
        return (boardTmp, boardPosTmp, posPlayer, H, W, boardInstructionTmp, instrPlayer)
    }
}
