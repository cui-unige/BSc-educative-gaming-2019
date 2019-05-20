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
    func actionPlayer(currentPlayer: Player, arrayP: [Player], nbP: Int, listTiles: inout [String], nbVisibleTiles: inout Int, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], boardInstruction: inout [String], instrPlayer: inout [String], boardLock: inout [String], H: Int, W: Int, skipTurn: inout Bool) -> (Player,  [String], [String], [String], [Int], [String], [String], [String], [Player]) {
        print("Your set of tiles: ", currentPlayer.cartes)
        for player in arrayP {
            if (player.id != currentPlayer.id && player.nom != "") {
                print("\(player.nom)'s set of tile: ", player.cartes)
            }
        }
        print("\nSELECT YOUR ACTION:")
        print("1 - Draw a tile          2 - Move on the map\n3 - Explore the map      4 - Remove a tile\n5 - Swap a tile          6 - Skip turn\n")
        let actionSelected = readLine()
        print("")
        if (actionSelected == "1") {
            if (listTiles == []) {
                print("No more tiles in the set !")
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else if (currentPlayer.cartes.count > 2) {
                print("You already have 3 tiles in your hand ! You can change one card !")
                let resReplace = replaceACard(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles)
                listTiles = resReplace.1
                return (resReplace.0, resReplace.1, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP)
            } else {
                let resDraw = drawACard(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles)
                listTiles = resDraw.1
                return (resDraw.0, resDraw.1, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP)
            }
        } else if (actionSelected == "2") {
            let resMove = movePlayer(currentPlayer: currentPlayer, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstr: boardInstruction, H: H, W: W)
            if !(resMove.4) {
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else {
                return (resMove.0, listTiles, resMove.1, resMove.2, resMove.3, boardInstruction, instrPlayer, boardLock, arrayP)
            }
        } else if (actionSelected == "3") {
            let resExplore = exploreMap(currentPlayer: currentPlayer, boardCase: &boardCase, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, H: H, W: W)
            if !(resExplore.4) {
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else {
                return (resExplore.0, listTiles, resExplore.1, boardPos, posPlayer, resExplore.2, resExplore.3, boardLock, arrayP)
            }
        }
            /*else if (actionSelected == "4") {
            let resLock = lockTile(currentPlayer: currentPlayer, boardLock: &boardLock, boardInstruction: boardInstruction, H: H, W: W)
            // a wrong selection allows player to select another action
            if !(resLock.2) {
                let _ = actionPlayer(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else {
                return (resLock.0, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, resLock.1)
            }
        } */
        
        else if (actionSelected == "4") {
            let resRemoveTile = removeTile(currentPlayer: currentPlayer, boardInstruction: &boardInstruction, listTiles: &listTiles, H: H, W: W)
            if !(resRemoveTile.3) {
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else {
                return (resRemoveTile.0, resRemoveTile.2, boardCase, boardPos, posPlayer, resRemoveTile.1, instrPlayer, boardLock, arrayP)
            }
        } else if (actionSelected == "5") {
            let resSwapTile = swapTile(currentPlayer: currentPlayer, arrayPlayer: arrayP, nbP: nbP)
            if !(resSwapTile.2) {
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else {
                return (currentPlayer, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP)
            }
        } else if (actionSelected == "6") {
            skipTurn = true
            return (currentPlayer, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP)
        }
        
        return (currentPlayer, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP)
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
        resRandomTiles.1.remove(at: tileSelected)
        resRandomTiles.0 = resRandomTiles.0 + resRandomTiles.1
        resRandomTiles.1 = []
        return (currentPlayer, resRandomTiles.0)
    }
    
    func replaceACard(currentPlayer: Player, listTiles: inout [String], nbVisibleTiles: inout Int) -> (Player, [String]) {
        var resRandomTiles = randomTiles(list: &listTiles, nbVisibleTiles: &nbVisibleTiles)
        print("Select a tile: ")
        var cmpt = 0
        for tile in resRandomTiles.1 {
            print("\(cmpt+1) - \(tile)")
            cmpt += 1
        }
        print("\(cmpt+1) - SKIP")
        var tileSelected = Int(readLine()!)!-1
        while (tileSelected < 0 || tileSelected > cmpt) {
            print("\nIncorrect input ! It must be between 1 and \(cmpt)\n")
            tileSelected = Int(readLine()!)!-1
        }
        // if skip
        if (tileSelected == 3) {
            return (currentPlayer, resRandomTiles.0)
        } else {
            var cmptP = 0
            // select one tile to change
            print("With which tile you want change ?")
            for tilePlayer in currentPlayer.cartes {
                print("\(cmptP+1) - \(tilePlayer)")
                cmptP += 1
            }
            let tileSelectedP = Int(readLine()!)!-1
            // remove the tile in hand
            let tmpTile = currentPlayer.cartes[tileSelectedP]
            currentPlayer.cartes.remove(at: tileSelectedP)
            // append the selected tile
            currentPlayer.cartes.append(resRandomTiles.1[tileSelected])
            resRandomTiles.1.remove(at: tileSelected)
            resRandomTiles.0 = resRandomTiles.0 + resRandomTiles.1
            resRandomTiles.0.append(tmpTile)
            resRandomTiles.1 = []
            return (currentPlayer, resRandomTiles.0)
        }
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
    
    func removeTile(currentPlayer: Player, boardInstruction: inout [String], listTiles: inout [String], H: Int, W: Int) -> (Player, [String], [String], Bool) {
        var valideAction: Bool
        let availablePosRemove = calculateAvailablePos(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, action: "POS")
        
        if (availablePosRemove.isEmpty) {
            valideAction = false
            print("There are no tile all around your position !\n")
        } else {
            print("Select a position to remove the tile on: ")
            var cmpt = 0
            for pos in availablePosRemove {
                print("\(cmpt+1) - ", pos)
                cmpt += 1
            }
            let posSelected = Int(readLine()!)!-1
            valideAction = true
            // tile removed go back in the game stack
            listTiles.append(boardInstruction[availablePosRemove[posSelected]])
            // remove the tile on the board
            boardInstruction[availablePosRemove[posSelected]] = ""
        }
        return (currentPlayer, boardInstruction, listTiles, valideAction)
    }
    
    func swapTile(currentPlayer: Player, arrayPlayer: [Player], nbP: Int) -> (Player, [Player], Bool) {
        var valideAction: Bool = true
        var tmpArrayPlayer = arrayPlayer.prefix(nbP)
        tmpArrayPlayer.remove(at: currentPlayer.id)
        
        var allPlayerCards: [String] = []
        for cardsPlayer in tmpArrayPlayer {
            allPlayerCards += cardsPlayer.cartes
        }
        
        if (currentPlayer.cartes.isEmpty) {
            valideAction = false
            print("You cannot swap a tile because your set is empty !")
        }
        // check if possible to swap with a mate
        else if (allPlayerCards.isEmpty) {
            valideAction = false
            print("You cannot swap a tile with another player because nobody have a tile!")
        } else {
            print("\nThe set of tiles of the others players (no empty): ")
            print("Select a player to swap a tile: ")
            var cmpt = 0
            for player in tmpArrayPlayer {
                if !(player.cartes.isEmpty) {
                    print("\(cmpt+1) (\(player.nom)) - ", player.cartes)
                    cmpt += 1
                }
            }
            let pSelected = Int(readLine()!)!-1

            print("\nWhich tile you want swap from your deck? ")
            var cmptY = 0
            for tY in currentPlayer.cartes {
                print("\(cmptY+1) - ", tY)
                cmptY += 1
            }
            let tileYSelected = Int(readLine()!)!-1
            
            print("\nWith which tile from \(tmpArrayPlayer[pSelected].nom)'s deck? ")
            var cmptO = 0
            for tO in tmpArrayPlayer[pSelected].cartes {
                print("\(cmptO+1) - ", tO)
                cmptO += 1
            }
            let tileOSelected = Int(readLine()!)!-1
            
            // swap cards
            let remYtile = currentPlayer.cartes[tileYSelected]
            let remOtile = tmpArrayPlayer[pSelected].cartes[tileOSelected]
            currentPlayer.cartes.remove(at: tileYSelected)
            tmpArrayPlayer[pSelected].cartes.remove(at: tileOSelected)
            currentPlayer.cartes.append(remOtile)
            tmpArrayPlayer[pSelected].cartes.append(remYtile)
            
            valideAction = true
        }
        return (currentPlayer, arrayPlayer, valideAction)
    }
    
    
    /*
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
     */
}
