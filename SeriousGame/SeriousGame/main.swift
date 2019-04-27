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


func beginGame(numberPlayer: Int, player1: Player, player2: Player, player3: Player, player4: Player, objective: [String], boardCase: [String], boardPos: [String], posPlayer: [String], H: Int, W: Int) {
    let arrayAllPlayers = [player1, player2, player3, player4]
    var turnPlayer = Int.random(in: 0...numberPlayer-1)
    var tmpListTiles = objective
    var visibleTiles = 3
    
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
            let res = Actions.actionPlayer(currentPlayer: arrayAllPlayers[turnPlayer], listTiles: &tmpListTiles, nbVisibleTiles: &visibleTiles, boardCase: boardCase, boardPos: boardPos, posPlayer: posPlayer, H: H, W: W)
            print("res --> ", res.0.nom, res.0.cartes, res.1)
        }
        turnPlayer = (turnPlayer + 1) % numberPlayer
    }
}

func main(nombreLine: Int, nombreCol: Int) {
    // Get informations of players - number - name
    var infoPlayers = welcome()
    
    // Initialisation of players
    let J1 = Player(nom: infoPlayers.1[0], cartes: [], position: String(((nombreLine*nombreCol)/2)-1))
    let J2 = Player(nom: infoPlayers.1[1], cartes: [], position: String((nombreLine*nombreCol)/2))
    let J3 = Player(nom: infoPlayers.1[2], cartes: [], position: String((nombreLine*nombreCol)/2))
    let J4 = Player(nom: infoPlayers.1[3], cartes: [], position: String((nombreLine*nombreCol)/2))
    
    let arrayPosPlayer = [J1.position, J2.position, J3.position, J4.position]
    print("\ninitial players: ", J1.nom, J2.nom, J3.nom, J4.nom)
    
    // Display rules for players
    displayRules()
    
    // Initialise the board
    var boardd = Array(repeating: "0", count: nombreLine*nombreCol)
    var boardP = Array(repeating: "", count: nombreLine*nombreCol)
    let resDisplay = Display.displayBoard(boardInit: &boardd, displayPos: &boardP, H: nombreLine, W: nombreCol, posPlayer: arrayPosPlayer)
    
    // Initialise objective - set of tiles
    let listTiles = ["tuile1","tuile2","tuile3","tuile4","tuile5","tuile6"]
    print(resDisplay)
    
    // Start the game
    beginGame(numberPlayer: infoPlayers.0, player1: J1, player2: J2, player3: J3, player4: J4, objective: listTiles, boardCase: resDisplay.0, boardPos: resDisplay.1, posPlayer: resDisplay.2, H: resDisplay.3, W: resDisplay.4)
}

// Start program
main(nombreLine: 9, nombreCol: 9)
