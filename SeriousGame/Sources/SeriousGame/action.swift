//
//  action.swift
//  SeriousGame
//
//  Created by cui on 23.04.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

class Action {
    
    let Interp = Interpretor()
    
    // return (Player info), (list of tiles in stack not selected), (board num of case), (board position of player) , (array of pos player (for display)), ...
    func actionPlayer(currentPlayer: Player, listTiles: inout [String], nbVisibleTiles: inout Int, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], boardInstruction: inout [String], instrPlayer: inout [String], boardLock: inout [String], H: Int, W: Int) -> (Player, [String], [String], [String], [Int], [String], [String], [String]) {
        print("Your set of tiles: ", currentPlayer.cartes)
        print("\nSELECT YOUR ACTION:")
        print("1 - Draw a card\n2 - Move on the map\n3 - Explore the map\n4 - Lock a tile")
        let actionSelected = readLine()
        if (actionSelected == "1") {
            if (listTiles == []) {
                print("No more tiles in the set !")
                let _ = actionPlayer(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W)
            } else {
                let resDraw = drawACard(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles)
                listTiles = resDraw.1
                return (resDraw.0, resDraw.1, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock)
            }
        } else if (actionSelected == "2") {
            let resMove = movePlayer(currentPlayer: currentPlayer, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstr: boardInstruction, H: H, W: W)
            if !(resMove.4) {
                let _ = actionPlayer(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W)
            } else {
                return (resMove.0, listTiles, resMove.1, resMove.2, resMove.3, boardInstruction, instrPlayer, boardLock)
            }
        } else if (actionSelected == "3") {
            let resExplore = exploreMap(currentPlayer: currentPlayer, boardCase: &boardCase, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, H: H, W: W)
            if !(resExplore.4) {
                let _ = actionPlayer(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W)
            } else {
                return (resExplore.0, listTiles, resExplore.1, boardPos, posPlayer, resExplore.2, resExplore.3, boardLock)
            }
        } else if (actionSelected == "4") {
            let resLock = lockTile(currentPlayer: currentPlayer, boardLock: &boardLock, boardInstruction: boardInstruction, H: H, W: W)
            // a wrong selection allows player to select another action
            if !(resLock.2) {
                let _ = actionPlayer(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W)
            } else {
                return (resLock.0, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, resLock.1)
            }
        }
        
        // case player skip action selected (miss click, etc ...)
        return (currentPlayer, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock)
    }
    
    func drawACard(currentPlayer: Player, listTiles: inout [String], nbVisibleTiles: inout Int) -> (Player, [String]) {
        var resRandomTiles = randomTiles(list: &listTiles, nbVisibleTiles: &nbVisibleTiles)
        print("Select a tile: ")
        var cmpt = 0
        for tile in resRandomTiles.1 {
            print("\(cmpt+1) - \(tile)")
            cmpt += 1
        }
        var tileSelected = Int(readLine()!)!-1
        while (tileSelected < 0 || tileSelected >= cmpt) {
            print("\nIncorrect input ! It must be between 1 and \(cmpt)\n")
            tileSelected = Int(readLine()!)!-1
        }
        currentPlayer.cartes.append(resRandomTiles.1[tileSelected])
        //let i = resRandomTiles.1.index(of: resRandomTiles.1[tileSelected])
        //resRandomTiles.1.remove(at: i!)
        resRandomTiles.1.remove(at: tileSelected)
        resRandomTiles.0 = resRandomTiles.0 + resRandomTiles.1
        resRandomTiles.1 = []
        return (currentPlayer, resRandomTiles.0)

    }
    
    // return : (listTiles, visibleTiles)
    func randomTiles(list: inout [String], nbVisibleTiles: inout Int) -> ([String], [String]) {
        var listUnveiledTiles: [String] = []
        list.shuffle()
        let sizeList = list.count
        if (sizeList < nbVisibleTiles+1) {
            listUnveiledTiles = list
            list.removeAll()
            print("\nList of tiles unveiled: ", listUnveiledTiles)
            return (list, listUnveiledTiles)
        } else {
            for _ in 0...nbVisibleTiles-1 {
                listUnveiledTiles.append(list[0])
                list.remove(at: 0)
            }
            print("\nList of tiles unveiled: ", listUnveiledTiles)
            return (list, listUnveiledTiles)
        }
    }
    
    func movePlayer(currentPlayer: Player, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], boardInstr: [String], H: Int, W: Int) -> (Player, [String], [String], [Int], Bool) {
        var valideAction: Bool
        let posP = currentPlayer.position
        
        // calculate available positions
        let availablePos = calculateAvailablePos(currentPlayer: currentPlayer, boardInstr: boardInstr, H: H, W: W, action: "POS")
        
        if (availablePos.isEmpty) {
            valideAction = false
            print("You have to explore the map before doing a move action !")
        } else {
            // remove last position
            boardPos[posP] = boardPos[posP].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
            // ask new position wanted
            print("Select a position: ")
            var cmpt = 0
            for pos in availablePos {
                print("\(cmpt+1) - Case numéro: \(pos)")
                cmpt += 1
            }
            let posSelected = Int(readLine()!)!-1
            valideAction = true
            // set the new position
            currentPlayer.position = availablePos[posSelected]
            boardPos[availablePos[posSelected]] = boardPos[availablePos[posSelected]] + String(currentPlayer.id+1) + " "
            posPlayer[currentPlayer.id] = currentPlayer.position
        }
        return (currentPlayer, boardCase, boardPos, posPlayer, valideAction)
    }
    
    
    func exploreMap(currentPlayer: Player, boardCase: inout [String], boardInstruction: inout [String], instrPlayer: inout [String], H: Int, W: Int) -> (Player, [String], [String], [String], Bool) {
        var valideAction: Bool
        print("Your set of tile: ", currentPlayer.cartes)
        print("You are on the case: ", currentPlayer.position)
        
        // ask which tile is wanted for this position
        if (currentPlayer.cartes.isEmpty) {
            valideAction = false
            print("Your set of tile is empty ! You can't explore the map before drowing a new tile !")
            // come back to select action
        } else {
            print("Select a tile: ")
            var cmpt = 0
            for tile in currentPlayer.cartes {
                print("\(cmpt+1) - ", tile)
                cmpt += 1
            }
            let tileSelected = Int(readLine()!)!-1
            
            let availablePosInstr = calculateAvailablePos(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, action: "INSTR")
            print("-->", availablePosInstr)
            // insert the tile in the instr's board
            // a tile can be posed only if no tile is already posed
            // it can be posed only with contact
            if (availablePosInstr.isEmpty) {
                valideAction = false
                print("There are already tile all around your position !")
            } else {
                print("Select a position: ")
                var cmpt = 0
                for pos in availablePosInstr {
                    print("\(cmpt+1) - ", pos)
                    cmpt += 1
                }
                let posSelected = Int(readLine()!)!-1
                valideAction = true
                print("ici: ",posSelected)
                
                // DO THIS IN LOCK ACT
                // test if pass the interpretor
                let resInter = Interp.checkTile()
                if (resInter) {
                    boardInstruction[availablePosInstr[posSelected]] = currentPlayer.cartes[tileSelected]
                    currentPlayer.cartes.remove(at: tileSelected)
                } else {
                    print("You can't put this tile on this pos. It doesn't respect the semantic !")
                }
            }
        }
        return (currentPlayer, boardCase, boardInstruction, instrPlayer, valideAction)
    }
    
    func calculateAvailablePos(currentPlayer: Player, boardInstr: [String], H: Int, W: Int, action: String) -> [Int] {
        var availablePos: [Int] = []
        // calculate available positions
        var leftside: [Int] = []
        var rightside: [Int] = []
        if !(0...W ~= currentPlayer.position) {
            // test if the case is empty
            if (action == "INSTR") {
                if (boardInstr[currentPlayer.position-W] == "") {
                    availablePos.append(currentPlayer.position-W)
                }
            }
            else if (action == "POS"){
                if !(boardInstr[currentPlayer.position-W] == "") {
                    availablePos.append(currentPlayer.position-W)
                }
            }
        }
        if !((H*W)-W...(H*W)-1 ~= currentPlayer.position) {
            if (action == "INSTR") {
                if (boardInstr[currentPlayer.position+W] == "") {
                    availablePos.append(currentPlayer.position+W)
                }

            }
            else if (action == "POS") {
                if !(boardInstr[currentPlayer.position+W] == "") {
                    availablePos.append(currentPlayer.position+W)
                }
            }
        }
        for i in 0...H-1 {
            leftside.append(i*W)
            rightside.append(((i+1)*W)-1)
        }
        if !(leftside.contains(currentPlayer.position)) {
            if (action == "INSTR") {
                if (boardInstr[currentPlayer.position-1] == "") {
                    availablePos.append(currentPlayer.position-1)
                }
            }
            else if (action == "POS") {
                if !(boardInstr[currentPlayer.position-1] == "") {
                    availablePos.append(currentPlayer.position-1)
                }
            }
        }
        if !(rightside.contains(currentPlayer.position)) {
            if (action == "INSTR") {
                if (boardInstr[currentPlayer.position+1] == "") {
                    availablePos.append(currentPlayer.position+1)
                }
            }
            else if (action == "POS") {
                if !(boardInstr[currentPlayer.position+1] == "") {
                    availablePos.append(currentPlayer.position+1)
                }
            }
        }
        return availablePos
    }
    
    func lockTile(currentPlayer: Player, boardLock: inout [String], boardInstruction: [String], H: Int, W: Int) -> (Player, [String], Bool) {
        var valideAction: Bool
        let s = String(repeating: " ", count: 4)
        // check if the current case is already locked
        if (boardLock[currentPlayer.position] == "[LOCKED]"+s) {
            valideAction = false
            print("The tile is already lock !")
        } else {
            valideAction = true
            boardLock[currentPlayer.position] = "[LOCKED]"+s
        }
        return (currentPlayer, boardLock, valideAction)
    }
}
