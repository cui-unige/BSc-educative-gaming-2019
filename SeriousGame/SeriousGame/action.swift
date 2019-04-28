//
//  action.swift
//  SeriousGame
//
//  Created by cui on 23.04.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

class Action {
    
    func actionPlayer(currentPlayer: Player, listTiles: inout [String], nbVisibleTiles: inout Int, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], H: Int, W: Int) -> (Player, [String]) { // + boardInstruction
        print("\nSELECT YOUR ACTION:")
        print("1 - Draw a card\n2 - Move on the map\n3 - Explore the map\n4 - Link tiles")
        let actionSelected = readLine()
        if (actionSelected == "1") {
            if (listTiles == []) {
                print("No more tiles in the set !")
                return (currentPlayer, [])
            } else {
                let resDraw = drawACard(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles)
                listTiles = resDraw.1
                return (resDraw.0, resDraw.1)
            }
        } else if (actionSelected == "2") {
            let resMove = movePlayer(currentPlayer: currentPlayer, boardCase: &boardCase, boardPos: &boardPos, posPlayer: &posPlayer, H: H, W: W)
            return (currentPlayer, resMove.2)
        }
        // afficher le plateau
        //Display.displayBoard(boardInit: <#T##[String]#>, displayPos: &<#T##[String]#>, H: <#T##Int#>, W: <#T##Int#>, posPlayer: <#T##[String]#>)
        return (currentPlayer, [])
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
    
    func movePlayer(currentPlayer: Player, boardCase: inout [String], boardPos: inout [String], posPlayer: inout [Int], H: Int, W: Int) -> (Player, [String], [String]) {
        print(" -->> ")
        var availablePos: [Int] = []
        let posP = currentPlayer.position
        print(posP)
        // remove last position
        boardPos[posP] = boardPos[posP].replacingOccurrences(of: String(currentPlayer.id), with: "")
        /*
        if (boardPos[posP].last == " ") {
            boardPos[posP] = boardPos[posP].replacingOccurrences(of: " ", with: "")
        }
        */
        
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
        
        return (currentPlayer, boardCase, boardPos)
    }
    
}
