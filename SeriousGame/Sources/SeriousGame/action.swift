//
//  action.swift
//  SeriousGame
//
//  Created by cui on 23.04.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

class Action {
    
    let color = "\u{001B}["
    let none = ";m"
    let black = ";30m"
    let red = ";31m"
    let green = ";32m"
    let yellow = ";33m"
    let blue = ";34m"
    let magenta = ";35m"
    let cyan = ";36m"
    let white = ";37m"
    
    let Interp = Interpretor()
    
    // return (Player info), (list of tiles in stack not selected), (board num of case), (board position of player) , (array of pos player (for display)), ...
    func actionPlayer(currentPlayer: Player, arrayP: [Player], nbP: Int, listTiles: inout [String], nbVisibleTiles: inout Int, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], boardInstruction: inout [String], instrPlayer: inout [String], boardLock: inout [String], H: Int, W: Int, skipTurn: inout Bool) -> (Player,  [String], [String], [String], [Int], [String], [String], [String], [Player], String) {
        print("Your set of tiles: ", currentPlayer.cartes)
        for player in arrayP {
            if (player.id != currentPlayer.id && player.nom != "") {
                print("\(player.nom)'s set of tile: ", player.cartes)
            }
        }
        print("\n\(color)0\(green)SELECT YOUR ACTION:")
        print("1 - Draw a tile          2 - Move on the map\n3 - Explore the map      4 - Remove a tile\n5 - Swap a tile          6 - Skip turn\n")
        let actionSelected = readLine()
        print("\(color)0\(none)")
        if (actionSelected == "1") {
            if (listTiles == []) {
                print("\(color)0\(red)No more tiles in the set !\(color)0\(none)")
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else if (currentPlayer.cartes.count > 2) {
                print("\(color)0\(blue)You already have 3 tiles in your hand ! You can change one card !\(color)0\(none)")
                let resReplace = replaceACard(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles)
                listTiles = resReplace.1
                return (resReplace.0, resReplace.1, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP, resReplace.2)
            } else {
                let resDraw = drawACard(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles)
                listTiles = resDraw.1
                return (resDraw.0, resDraw.1, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP, resDraw.2)
            }
        } else if (actionSelected == "2") {
            let resMove = movePlayer(currentPlayer: currentPlayer, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstr: boardInstruction, H: H, W: W)
            if !(resMove.4) {
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else {
                return (resMove.0, listTiles, resMove.1, resMove.2, resMove.3, boardInstruction, instrPlayer, boardLock, arrayP, resMove.5)
            }
        } else if (actionSelected == "3") {
            let resExplore = exploreMap(currentPlayer: currentPlayer, boardCase: &boardCase, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, H: H, W: W)
            if !(resExplore.4) {
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else {
                return (resExplore.0, listTiles, resExplore.1, boardPos, posPlayer, resExplore.2, resExplore.3, boardLock, arrayP, resExplore.5)
            }
        }
        else if (actionSelected == "4") {
            let resRemoveTile = removeTile(currentPlayer: currentPlayer, boardInstruction: &boardInstruction, listTiles: &listTiles, boardPos: &boardPos, posPlayer: &posPlayer, H: H, W: W)
            if !(resRemoveTile.3) {
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else {
                return (resRemoveTile.0, resRemoveTile.2, boardCase, boardPos, posPlayer, resRemoveTile.1, instrPlayer, boardLock, arrayP, resRemoveTile.4)
            }
        } else if (actionSelected == "5") {
            let resSwapTile = swapTile(currentPlayer: currentPlayer, arrayPlayer: arrayP, nbP: nbP)
            if !(resSwapTile.2) {
                let _ = actionPlayer(currentPlayer: currentPlayer, arrayP: arrayP, nbP: nbP, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, boardLock: &boardLock, H: H, W: W, skipTurn: &skipTurn)
            } else {
                return (currentPlayer, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP, resSwapTile.3)
            }
        } else if (actionSelected == "6") {
            skipTurn = true
            let logSkip = "\(color)1\(green)* You skiped your turn \(color)0\(none)\n"
            return (currentPlayer, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP, logSkip)
        }
        
        return (currentPlayer, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer, boardLock, arrayP, "")
    }
    
    func drawACard(currentPlayer: Player, listTiles: inout [String], nbVisibleTiles: inout Int) -> (Player, [String], String) {
        var resRandomTiles = randomTiles(list: &listTiles, nbVisibleTiles: &nbVisibleTiles)
        print("\(color)0\(blue)Select a tile: \(color)0\(none)")
        var cmpt = 0
        for tile in resRandomTiles.1 {
            print("\(cmpt+1) - \(tile)")
            cmpt += 1
        }
        var tileSelected = Int(readLine()!)!-1
        while (tileSelected < 0 || tileSelected >= cmpt) {
            print("\n\(color)0\(red)Incorrect input ! It must be between 1 and \(cmpt)\n\(color)0\(none)")
            tileSelected = Int(readLine()!)!-1
        }
        let logDrawACard = "\(color)1\(green)* You appended your set with the following tile [\(resRandomTiles.1[tileSelected])]\(color)0\(none)\n"
        currentPlayer.cartes.append(resRandomTiles.1[tileSelected])
        resRandomTiles.1.remove(at: tileSelected)
        resRandomTiles.0 = resRandomTiles.0 + resRandomTiles.1
        resRandomTiles.1 = []
        return (currentPlayer, resRandomTiles.0, logDrawACard)
    }
    
    func replaceACard(currentPlayer: Player, listTiles: inout [String], nbVisibleTiles: inout Int) -> (Player, [String], String) {
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
            print("\n\(color)0\(red)Incorrect input ! It must be between 1 and \(cmpt)\n\(color)0\(none)")
            tileSelected = Int(readLine()!)!-1
        }
        // if skip
        if (tileSelected == 3) {
            let logReplaceACard = "\(color)1\(green)* You skiped the replacement\(color)0\(none)\n"
            return (currentPlayer, resRandomTiles.0, logReplaceACard)
        } else {
            var cmptP = 0
            // select one tile to change
            print("\(color)0\(blue)With which tile you want change ?\(color)0\(none)")
            for tilePlayer in currentPlayer.cartes {
                print("\(cmptP+1) - \(tilePlayer)")
                cmptP += 1
            }
            let tileSelectedP = Int(readLine()!)!-1
            // remove the tile in hand
            let tmpTile = currentPlayer.cartes[tileSelectedP]
            var logReplaceACard = "\(color)1\(green)* You removed the tile [\(tmpTile)] from your set\(color)0\(none)\n"
            currentPlayer.cartes.remove(at: tileSelectedP)
            // append the selected tile
            logReplaceACard += "\(color)1\(green) * You add the tile [\(resRandomTiles.1[tileSelected])] in your deck\(color)0\(none)\n"
            currentPlayer.cartes.append(resRandomTiles.1[tileSelected])
            resRandomTiles.1.remove(at: tileSelected)
            resRandomTiles.0 = resRandomTiles.0 + resRandomTiles.1
            resRandomTiles.0.append(tmpTile)
            resRandomTiles.1 = []
            return (currentPlayer, resRandomTiles.0, logReplaceACard)
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
    
    func movePlayer(currentPlayer: Player, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], boardInstr: [String], H: Int, W: Int) -> (Player, [String], [String], [Int], Bool, String) {
        var valideAction: Bool
        let posP = currentPlayer.position
        var logMovePlayer: String = ""
        
        // calculate available positions
        let availablePos = calculateAvailablePos(currentPlayer: currentPlayer, boardInstr: boardInstr, H: H, W: W, action: "POS")
        
        if (availablePos.isEmpty) {
            valideAction = false
            print("\(color)0\(red)You have to explore the map before doing a move action !\n\(color)0\(none)")
        } else {
            // remove last position
            boardPos[posP] = boardPos[posP].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
            // ask new position wanted
            print("\(color)0\(blue)Select a position: \(color)0\(none)")
            var cmpt = 0
            for pos in availablePos {
                print("\(cmpt+1) - Case number: \(pos)")
                cmpt += 1
            }
            let posSelected = Int(readLine()!)!-1
            valideAction = true
            // set the new position
            logMovePlayer = "\(color)1\(green)* You changed your position from [\(posP)] to [\(availablePos[posSelected])]\(color)0\(none)\n"
            currentPlayer.position = availablePos[posSelected]
            boardPos[availablePos[posSelected]] = boardPos[availablePos[posSelected]] + String(currentPlayer.id+1) + " "
            posPlayer[currentPlayer.id] = currentPlayer.position
        }
        return (currentPlayer, boardCase, boardPos, posPlayer, valideAction, logMovePlayer)
    }
    
    
    func exploreMap(currentPlayer: Player, boardCase: inout [String], boardInstruction: inout [String], instrPlayer: inout [String], H: Int, W: Int) -> (Player, [String], [String], [String], Bool, String) {
        var valideAction: Bool
        var logExploreMap: String = ""
        print("Your set of tile: ", currentPlayer.cartes)
        print("You are on the case: ", currentPlayer.position)
        
        // ask which tile is wanted for this position
        if (currentPlayer.cartes.isEmpty) {
            valideAction = false
            print("\(color)0\(red)Your set of tile is empty ! You can't explore the map before drowing a new tile !\n\(color)0\(none)")
            // come back to select action
        } else {
            print("\(color)0\(blue)Select a tile: \(color)0\(none)")
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
                print("\(color)0\(red)There are already tiles all around your position !\n\(color)0\(none)")
            } else {
                print("\(color)0\(blue)Select a position: \(color)0\(none)")
                var cmpt = 0
                for pos in availablePosInstr {
                    print("\(cmpt+1) - ", pos)
                    cmpt += 1
                }
                let posSelected = Int(readLine()!)!-1
                valideAction = true
                
                // test if pass the interpretor
                let resInter = Interp.checkTile()
                if (resInter) {
                    logExploreMap = "\(color)1\(green)* You posed the tile [\(currentPlayer.cartes[tileSelected])] to the position [\(availablePosInstr[posSelected])]\(color)0\(none)\n"
                    boardInstruction[availablePosInstr[posSelected]] = currentPlayer.cartes[tileSelected]
                    currentPlayer.cartes.remove(at: tileSelected)
                } else {
                    print("\(color)0\(red)You can't put this tile on this pos. It doesn't respect the semantic !\n\(color)0\(none)")
                }
            }
        }
        return (currentPlayer, boardCase, boardInstruction, instrPlayer, valideAction, logExploreMap)
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
    
    func removeTile(currentPlayer: Player, boardInstruction: inout [String], listTiles: inout [String], boardPos: inout [String], posPlayer: inout [Int], H: Int, W: Int) -> (Player, [String], [String], Bool, String) {
        var valideAction: Bool
        var logRemoveTile: String = ""
        let availablePosRemoveRes = calculateAvailablePos(currentPlayer: currentPlayer, boardInstr: boardInstruction, H: H, W: W, action: "POS")
        var availablePosRemove: [Int] = []
        let center = (H*W)/2
        for i in availablePosRemoveRes {
            if !(i == center) {
                availablePosRemove.append(i)
            }
            var ind = 0
            for pP in posPlayer {
                if (availablePosRemove.contains(pP)) {
                    availablePosRemove.remove(at: ind)
                } else {
                    ind += 1
                }
            }
        }
        
        if (availablePosRemove.isEmpty) {
            valideAction = false
            print("\(color)0\(red)There are no tile to remove all around your position !\n\(color)0\(none)")
        } else {
            print("\(color)0\(blue)Select a position to remove the tile on: \(color)0\(none)")
            var cmpt = 0
            for pos in availablePosRemove {
                print("\(cmpt+1) - ", pos)
                cmpt += 1
            }
            let posSelected = Int(readLine()!)!-1
            valideAction = true
            // tile removed go back in the game stack
            logRemoveTile = "\(color)1\(green)* You remove the tile [\(boardInstruction[availablePosRemove[posSelected]])] in the position [\(availablePosRemove[posSelected])]\(color)0\(none)\n"
            listTiles.append(boardInstruction[availablePosRemove[posSelected]])
            // remove the tile on the board
            boardInstruction[availablePosRemove[posSelected]] = ""
        }
        return (currentPlayer, boardInstruction, listTiles, valideAction, logRemoveTile)
    }
    
    func swapTile(currentPlayer: Player, arrayPlayer: [Player], nbP: Int) -> (Player, [Player], Bool, String) {
        var valideAction: Bool = true
        var logSwapTile: String = ""
        var tmpArrayPlayer = arrayPlayer.prefix(nbP)
        tmpArrayPlayer.remove(at: currentPlayer.id)
        
        var allPlayerCards: [String] = []
        for cardsPlayer in tmpArrayPlayer {
            allPlayerCards += cardsPlayer.cartes
        }
        
        if (currentPlayer.cartes.isEmpty) {
            valideAction = false
            print("\(color)0\(red)You cannot swap a tile because your set is empty !\n\(color)0\(none)")
        }
        // check if possible to swap with a mate
        else if (allPlayerCards.isEmpty) {
            valideAction = false
            print("\(color)0\(red)You cannot swap a tile with another player because nobody have a tile !\n\(color)0\(none)")
        } else {
            print("\nThe set of tiles of the others players (no empty): ")
            print("\(color)0\(blue)Select a player to swap a tile: \(color)0\(none)")
            var cmpt = 0
            for player in tmpArrayPlayer {
                if !(player.cartes.isEmpty) {
                    print("\(cmpt+1) (\(player.nom)) - ", player.cartes)
                    cmpt += 1
                }
            }
            let pSelected = Int(readLine()!)!-1

            print("\n\(color)0\(blue)Which tile you want swap from your deck? \(color)0\(none)")
            var cmptY = 0
            for tY in currentPlayer.cartes {
                print("\(cmptY+1) - ", tY)
                cmptY += 1
            }
            let tileYSelected = Int(readLine()!)!-1
            
            print("\n\(color)0\(blue)With which tile from \(tmpArrayPlayer[pSelected].nom)'s deck? \(color)0\(none)")
            var cmptO = 0
            for tO in tmpArrayPlayer[pSelected].cartes {
                print("\(cmptO+1) - ", tO)
                cmptO += 1
            }
            let tileOSelected = Int(readLine()!)!-1
            
            // swap cards
            let remYtile = currentPlayer.cartes[tileYSelected]
            let remOtile = tmpArrayPlayer[pSelected].cartes[tileOSelected]
            logSwapTile = "\(color)1\(green)* You swap a tile with [\(tmpArrayPlayer[pSelected].nom)]\n * Your tile exchanged is [\(remYtile)]\n * \(tmpArrayPlayer[pSelected].nom)'s tile exchanged is [\(remOtile)]\(color)0\(none)\n"

            currentPlayer.cartes.remove(at: tileYSelected)
            tmpArrayPlayer[pSelected].cartes.remove(at: tileOSelected)
            currentPlayer.cartes.append(remOtile)
            tmpArrayPlayer[pSelected].cartes.append(remYtile)
            
            valideAction = true
        }
        return (currentPlayer, arrayPlayer, valideAction, logSwapTile)
    }
    
}
