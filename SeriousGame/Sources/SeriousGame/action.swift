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
    func actionPlayer(currentPlayer: Player, listTiles: inout [String], nbVisibleTiles: inout Int, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], boardInstruction: inout [String], instrPlayer: inout [String], H: Int, W: Int) -> (Player, [String], [String], [String], [Int], [String], [String]) {
        print("Your set of tiles: ", currentPlayer.cartes)
        print("\nSELECT YOUR ACTION:")
        print("1 - Draw a card\n2 - Move on the map\n3 - Explore the map\n4 - Link tiles")
        let actionSelected = readLine()
        if (actionSelected == "1") {
            if (listTiles == []) {
                print("No more tiles in the set !")
                return (currentPlayer, [], boardCase, boardPos, posPlayer, boardInstruction, instrPlayer)
            } else {
                let resDraw = drawACard(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles)
                listTiles = resDraw.1
                return (resDraw.0, resDraw.1, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer)
            }
        } else if (actionSelected == "2") {
            let resMove = movePlayer(currentPlayer: currentPlayer, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, H: H, W: W)
            print("boardPos: ", resMove.2)
            print("posPlayer: ", resMove.3)
            return (resMove.0, listTiles, resMove.1, resMove.2, resMove.3, boardInstruction, instrPlayer)
        } else if (actionSelected == "3") {
            let resExplore = exploreMap(currentPlayer: currentPlayer, boardCase: &boardCase, boardInstruction: &boardInstruction, instrPlayer: &instrPlayer, H: H, W: W)
            return (resExplore.0, listTiles, resExplore.1, boardPos, posPlayer, resExplore.2, resExplore.3)
        }
        
        // case player skip action selected (miss click, etc ...)
        return (currentPlayer, listTiles, boardCase, boardPos, posPlayer, boardInstruction, instrPlayer)
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
        let i = resRandomTiles.1.index(of: resRandomTiles.1[tileSelected])
        resRandomTiles.1.remove(at: i!)
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
            //print("List of tiles: ", list)
            print("\nList of tiles unveiled: ", listUnveiledTiles)
            return (list, listUnveiledTiles)
        } else {
            for _ in 0...nbVisibleTiles-1 {
                listUnveiledTiles.append(list[0])
                list.remove(at: 0)
            }
            //print("List of tiles: ", list)
            print("\nList of tiles unveiled: ", listUnveiledTiles)
            return (list, listUnveiledTiles)
        }
    }
    
    func movePlayer(currentPlayer: Player, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], H: Int, W: Int) -> (Player, [String], [String], [Int]) {
        print(" -->> ")
        var availablePos: [Int] = []
        let posP = currentPlayer.position
        print(posP)
        // remove last position
        boardPos[posP] = boardPos[posP].replacingOccurrences(of: "\(String(currentPlayer.id+1)) ", with: "")
        
        // calculate available positions
        var leftside: [Int] = []
        var rightside: [Int] = []
        if !(0...W ~= currentPlayer.position) {
            availablePos.append(currentPlayer.position-W)
        }
        if !((H*W)-W...(H*W)-1 ~= currentPlayer.position) {
            availablePos.append(currentPlayer.position+W)
        }
        for i in 0...H-1 {
            leftside.append(i*W)
            rightside.append(((i+1)*W)-1)
        }
        if !(leftside.contains(currentPlayer.position)) {
            availablePos.append(currentPlayer.position-1)
        }
        if !(rightside.contains(currentPlayer.position)) {
            availablePos.append(currentPlayer.position+1)
        }
        
        // ask new position wanted
        print("Select a position: ")
        var cmpt = 0
        for pos in availablePos {
            print("\(cmpt+1) - Case numéro: \(pos)")
            cmpt += 1
        }
        let posSelected = Int(readLine()!)!-1
        
         // set the new position
        currentPlayer.position = availablePos[posSelected]
        boardPos[availablePos[posSelected]] = boardPos[availablePos[posSelected]] + String(currentPlayer.id+1) + " "
        posPlayer[currentPlayer.id] = currentPlayer.position
        
        return (currentPlayer, boardCase, boardPos, posPlayer)
    }
    
    
    func exploreMap(currentPlayer: Player, boardCase: inout [String], boardInstruction: inout [String], instrPlayer: inout [String], H: Int, W: Int) -> (Player, [String], [String], [String]) {
        print("Your set of tile: ", currentPlayer.cartes)
        print("You are on the case: ", currentPlayer.position)
        print("board instr: --> ", boardInstruction)
        
        // ask which tile is wanted for this position
        if (currentPlayer.cartes.isEmpty) {
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
            
            // insert the tile in the instr's board
            // a tile can be posed only if no tile is already posed
            if !(boardInstruction[currentPlayer.position].isEmpty) {
                print("There is already a tile in this position !")
                // return to select action
            } else {
                // test if pass the interpretor
                let resInter = Interp.checkTile()
                if (resInter) {
                    boardInstruction[currentPlayer.position] = currentPlayer.cartes[tileSelected]
                    currentPlayer.cartes.remove(at: tileSelected)
                } else {
                    print("You can't put this tile on this pos. It doesn't respect the semantic !")
                }
            }
        }
        return (currentPlayer, boardCase, boardInstruction, instrPlayer)
    }
}
