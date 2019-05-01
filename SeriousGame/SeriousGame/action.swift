//
//  action.swift
//  SeriousGame
//
//  Created by cui on 23.04.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

class Action {
    
    // return (Player info), (list of tiles in stack not selected), (board num of case), (board position of player) , (array of pos player (for display)), ...
    func actionPlayer(currentPlayer: Player, listTiles: inout [String], nbVisibleTiles: inout Int, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], H: Int, W: Int) -> (Player, [String], [String], [String], [Int]) { // + boardInstruction
        print("\nSELECT YOUR ACTION:")
        print("1 - Draw a card\n2 - Move on the map\n3 - Explore the map\n4 - Link tiles")
        let actionSelected = readLine()
        if (actionSelected == "1") {
            if (listTiles == []) {
                print("No more tiles in the set !")
                return (currentPlayer, [], boardCase, boardPos, posPlayer)
            } else {
                let resDraw = drawACard(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles)
                listTiles = resDraw.1
                return (resDraw.0, resDraw.1, boardCase, boardPos, posPlayer)
            }
        } else if (actionSelected == "2") {
            let resMove = movePlayer(currentPlayer: currentPlayer, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, H: H, W: W)
            print("boardPos: ", resMove.2)
            print("posPlayer: ", resMove.3)
            return (resMove.0, listTiles, resMove.1, resMove.2, resMove.3)
        }
        
        // case player skip action selected (miss click, etc ...)
        return (currentPlayer, listTiles, boardCase, boardPos, posPlayer)
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
        boardPos[posP] = boardPos[posP].replacingOccurrences(of: "\(String(currentPlayer.id)) ", with: "")
        
        // calculate available positions
        availablePos.append(currentPlayer.position+1)
        availablePos.append(currentPlayer.position-1)
        availablePos.append(currentPlayer.position+W)
        availablePos.append(currentPlayer.position-W)
        
        
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
        boardPos[availablePos[posSelected]] = boardPos[availablePos[posSelected]] + String(currentPlayer.id) + " "
        posPlayer[currentPlayer.id] = currentPlayer.position
        
        return (currentPlayer, boardCase, boardPos, posPlayer)
    }
    
}
