//
//  action.swift
//  SeriousGame
//
//  Created by cui on 23.04.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

class Action {
    
    func actionPlayer(currentPlayer: Player, listTiles: inout [String], nbVisibleTiles: inout Int, boardCase: [String], boardPos: [String], posPlayer: [String], H: Int, W: Int) -> (Player, [String]) {
        print("\nSELECT YOUR ACTION:")
        print("1 - Draw a card\n2 - Move on the map\n3 - Explore the map\n4 - Link tiles")
        let actionSelected = readLine()
        if (actionSelected == "1") {
            if (listTiles == []) {
                print("No more tiles in the set !")
                return (currentPlayer, [])
            } else {
                let res = drawACard(currentPlayer: currentPlayer, listTiles: &listTiles, nbVisibleTiles: &nbVisibleTiles)
                listTiles = res.1
                return (res.0, res.1)
            }
        } else if (actionSelected == "2") {
            //Display.displayBoard(boardInit: <#T##[String]#>, displayPos: &<#T##[String]#>, H: <#T##Int#>, W: <#T##Int#>, posPlayer: <#T##[String]#>)
            //return ("ok", []) tous les types
        }
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
    
}
