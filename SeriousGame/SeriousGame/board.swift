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
            for _ in 1...2 {
                for _ in 1...n {
                    print("|                ", terminator: "");
                }
                puts("|");
            }
        } else {
            for _ in 1...3 {
                puts("|")
                for _ in 1...n {
                    print("|                ", terminator: "");
                }
            }
        }
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
            if (displayCase[tmp].count == 1) {
                let s = String(repeating: " ", count: 14)
                print("|"+s, displayCase[tmp], terminator: "")
            } else if (displayCase[tmp].count == 2) {
                let s = String(repeating: " ", count: 13)
                print("|"+s, displayCase[tmp], terminator: "")
            } else if (displayCase[tmp].count == 3) {
                let s = String(repeating: " ", count: 12)
                    print("|"+s, displayCase[tmp], terminator: "")
            }
            tmp += 1
        }
    }
    
    func displayPosPlayer(n: Int,  displayPos: inout [String], currentPosPlayer: [Int], tmp: inout Int) {
        for _ in 0...n-1 {
            for p in 0...3 {
                if (currentPosPlayer[p] == tmp) {
                    displayPos[tmp] += String(p) + " "
                }
            }
            if (displayPos[tmp].count == 0) {
                let s = String(repeating: " ", count: 15)
                print("|"+s, displayPos[tmp], terminator: "")
            } else if (displayPos[tmp].count == 2) {
                let s = String(repeating: " ", count: 13)
                print("|"+s, displayPos[tmp], terminator: "")
            } else if (displayPos[tmp].count == 4) {
                let s = String(repeating: " ", count: 11)
                print("|"+s, displayPos[tmp], terminator: "")
            } else if (displayPos[tmp].count == 6) {
                let s = String(repeating: " ", count: 9)
                print("|"+s, displayPos[tmp], terminator: "")
            } else if (displayPos[tmp].count == 8) {
                let s = String(repeating: " ", count: 7)
                print("|"+s, displayPos[tmp], terminator: "")
            }
            tmp += 1
        }
    }

    func displayBoard(boardInit: inout [String], displayPos: inout [String], H: Int, W: Int, posPlayer: [Int]) -> ([String], [String], [Int], Int, Int) {
        var tmp = 0
        var tmp2 = 0
        var boardTmp = boardInit
        var boardPosTmp = displayPos
        
        
        for _ in 0...((boardInit.count)/W)-1 {
            lineBoard(n: W)
            displayNumCase(n: W, displayCase: &boardTmp, tmp: &tmp)
            lineCompl(n: W, action: "JUMP")
            puts("|")
            displayPosPlayer(n: W,  displayPos: &boardPosTmp, currentPosPlayer: posPlayer, tmp: &tmp2)
            puts("|")
        }
        lineBoard(n: W)
        return (boardTmp, boardPosTmp, posPlayer, H, W)
    }
}
