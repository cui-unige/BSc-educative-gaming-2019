//
//  main.swift
//  SeriousGame
//
//  Created by cui on 29.03.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

let Display = Board()
let Actions = Action()
let maxPlayer = 4

func askNamePlayer(numPlayers: Int) -> [String] {
    var arrayPlayer = Array(repeating: "", count: maxPlayer)
    for players in 0...numPlayers-1 {
        print("NAME OF PLAYER \(players+1): ", terminator: "")
        let namePlayer = readLine()
        arrayPlayer[players] = namePlayer!
    }
    return arrayPlayer
}

func welcome() -> (nbP: Int, [String]) { // (nbPlayer: Int, namePlayer: [String])
    print("WELCOME TO SPACE ENCORDERS\n")
    print("ENTER THE NUMBER OF PLAYER: ", terminator: "")
    let nbPlayer = readLine()!
    let enumPlayer = askNamePlayer(numPlayers: Int(nbPlayer)!)
    return (Int(nbPlayer)!, enumPlayer)
}

func displayRules() {
    let nbCardsWay = 36
    print("\nGOALS & RULES:\n")
    print("The goal of this game is to create a path with way cards (\(nbCardsWay)) in order to get the rocket off the ground when everything is well connected in the right order ! There are several unforeseen during the game.\nEach turn, each player draws a card. He can do four actions per turn between - draw a way card - explore -  ....\nAfter having do a correct program, the game is win and every player have won ! But if one of all players lose his whole life, every player of the game lost the game !")
    print("\n\n")
}


func beginGame(numberPlayer: Int, player1: Player, player2: Player, player3: Player, player4: Player, objective: [String], boardCase: [String], boardPos: [String], posPlayer: [Int], boardInstruction: [String], instrPlayer: [String], H: Int, W: Int) {
    let arrayAllPlayers = [player1, player2, player3, player4]
    var turnPlayer = Int.random(in: 0...numberPlayer-1)
    var tmpListTiles = objective
    var visibleTiles = 3
    var tmpBoardPos = boardPos
    var tmpBoardCase = boardCase
    var tmpPosPlayer = posPlayer
    var tmpBoardInstruction = boardInstruction
    var tmpInstrPlayer = instrPlayer
    // Stop the game
    var gameFinished = false
    var countTurn = 0
    var deadline = 10
    //var healthPlayer = Array(repeating: hpMax, count: numberPlayer) ?
    //var onePlayerDead = false
    
    while gameFinished != true {
        countTurn += 1
        // One entire turn decrease deadline which is global for all players
        if (countTurn == numberPlayer) {
            deadline -= 1
            countTurn = 0
        }
        if (deadline == 0) {
            gameFinished = true
        } else {
            print("\nIt's \(arrayAllPlayers[turnPlayer].nom)'s turn !")
            var res = Actions.actionPlayer(currentPlayer: arrayAllPlayers[turnPlayer], listTiles: &tmpListTiles, nbVisibleTiles: &visibleTiles, boardCase: &tmpBoardCase, boardPos: &tmpBoardPos, posPlayer: &tmpPosPlayer, boardInstruction: &tmpBoardInstruction, instrPlayer: &tmpInstrPlayer, H: H, W: W)
            print("res player name:  --> ", res.0.nom)
            print("res player deck:  --> ", res.0.cartes)
            print("res stack tiles:  --> ", res.1)
            print("res board num case:  --> ", res.2)
            print("res board pos player:  --> ", res.3)
            print("res array pos player:  --> ", res.4)
            print("res board instruction: --> ", res.5)
            Display.displayBoard(boardInit: &res.2, displayPos: &res.3, displayInstruction: &res.5, H: H, W: W, posPlayer: &res.4, instrPlayer: &res.6)
        }
        turnPlayer = (turnPlayer + 1) % numberPlayer
    }
}

func main(nombreLine: Int, nombreCol: Int) {
    // Get informations of players - number - name
    var infoPlayers = welcome()
    
    // Initialisation of players
    let J1 = Player(id: 0, nom: infoPlayers.1[0], cartes: [], position: 5)
    let J2 = Player(id: 1, nom: infoPlayers.1[1], cartes: [], position: (nombreLine*nombreCol)/2)
    let J3 = Player(id: 2, nom: infoPlayers.1[2], cartes: [], position: (nombreLine*nombreCol)/2)
    let J4 = Player(id: 3, nom: infoPlayers.1[3], cartes: [], position: (nombreLine*nombreCol)/2)
    
    let tmpArrayPosPlayer = [J1.position, J2.position, J3.position, J4.position]
    var arrayPosPlayer: [Int] = []
    for i in 0...infoPlayers.0-1 {
        arrayPosPlayer.append(tmpArrayPosPlayer[i])
    }
    print("\ninitial players: ", J1.nom, J2.nom, J3.nom, J4.nom)
    
    var arrayInstructionPlayer: [String] = []
    
    // Display rules for players
    displayRules()
    
    // Initialise the board
    var boardd = Array(repeating: "0", count: nombreLine*nombreCol)
    var boardP = Array(repeating: "", count: nombreLine*nombreCol)
    var boardI = Array(repeating: "", count: nombreLine*nombreCol)
    let resDisplay = Display.displayBoard(boardInit: &boardd, displayPos: &boardP, displayInstruction: &boardI, H: nombreLine, W: nombreCol, posPlayer: &arrayPosPlayer, instrPlayer: &arrayInstructionPlayer)
    
    // Initialise objective - set of tiles
    let listTiles = ["tuile1","tuile2","tuile3","tuile4","tuile5","tuile6"]
    
    // Start the game
    beginGame(numberPlayer: infoPlayers.0, player1: J1, player2: J2, player3: J3, player4: J4, objective: listTiles, boardCase: resDisplay.0, boardPos: resDisplay.1, posPlayer: resDisplay.2, boardInstruction: resDisplay.5, instrPlayer: resDisplay.6, H: resDisplay.3, W: resDisplay.4)
}

// Start program
main(nombreLine: 9, nombreCol: 9)
