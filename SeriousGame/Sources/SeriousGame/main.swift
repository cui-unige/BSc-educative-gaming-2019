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

// max player for a game -> add min to 2
let maxPlayer = 4

// definition of storm cards
let eclair = "Eclair"
let bourasque = "Bourasque"
let ventTourneHoraire = "Vent Tourne Horaire"
let ventTourneAntiHoraire = "Vent Tourne Anti-Horaire"
let dechainement = "Orage se dechaine"
let dechainement2 = "Orage se dechaine + Melange pile"

// definition of equip cards  --> REMOVE
let threeAction = "+3 action"
let swapTile = "Echanger une tuiles"
let shieldBourasque = "Protege de la bourasque"
let removeInt = "Remove(Int)"
let pop = "Pop()"
let replace = "Replace()"
let addPV = "+1 PV"
let shieldStorm = "Protege de l'eclair"
let reverseStack = "Reverse()"
let shuffleStack = "Shuffle()"

// definition of objectives
let objective_countdown: [String] = ["BEGIN", "while", "n", "! = 0", "show(n)", "n--", "END"]
let objective_ckeckTeam: [String] = ["BEGIN", "for", "i in list", "n++", "if", "n", "== len(list)", "END"]
let objective_checkFuel: [String] = ["BEGIN", "if", "fuel", ">= (d_l/c_f)*2", "check()", "else", "while", "cur_fuel", "!= fuel", "fill", "END"]
let objective_autoPilot: [String] = ["BEGIN", "if", "cur_dist", "<= (1/3)*d_lune", "s = take_off", "else if", "cur_dist", "> (2/3)*d_lune", "s = landing", "else", "s = fly", "END"]
let objective_checkTask: [String] = ["BEGIN", "for", "i in list", "if", "check(i)", "== true", "continue", "else", "check(i) == true", "END"]
let objective_checkEngine: [String] = ["BEGIN", "if", "temp", "> right_temp", "check()", "else", "while", "temp", "!= right_temp", "warm()", "check()", "END"]



func askNamePlayer(numPlayers: Int) -> [String] {
    var arrayPlayer = Array(repeating: "", count: maxPlayer)
    for players in 0...numPlayers-1 {
        print("Name of player \(players+1): ", terminator: "")
        let namePlayer = readLine()
        arrayPlayer[players] = namePlayer!
    }
    return arrayPlayer
}

func welcome() -> (nbP: Int, [String]) { // (nbPlayer: Int, namePlayer: [String])
    print("WELCOME TO SPACE ENCORDERS\n")
    print("ENTER THE NUMBER OF PLAYER (2-4): ", terminator: "")
    let nbPlayer = readLine()!
    let enumPlayer = askNamePlayer(numPlayers: Int(nbPlayer)!)
    return (Int(nbPlayer)!, enumPlayer)
}

func displayRules() {
    print("\nGOALS:")
    print("The goal of this game is to create several algorithms with tiles in order to allow the rocket to take off. The tiles must be well connected ! this game is based on cooperation so you are advised to play with your allies ! But be careful, you have to be fast enough to build everything before the end of time !")
    
    print("\nRULES:")
    print("Firsty every player begin in the center of the map (in the same case of the Rocket). The algorithms to build are selected randomly (number of player = number of algorithms to build) ! Each turn, each player can do 4 actions or less. He has the choice between : (1) Draw a card, (2) Move on the map, (3) Explore the map, (4) Remove a tile, (5) Swap a tile, (6) Skip turn. Moreover there are several unforeseen during the game : The storm cards. It happend every end of turn of a player ! The more the gauge is high, the more storm cards are applied ! When every algorithms are well constructed before the end of the deadline and if every player are in the center, the game is win !")
    
    print("\nThe effect of action are the followings:\n[Draw a tile] : choose a tile from the draw stack\n[Move on the map] : move on tiles\n[Explore the map] : place a tile on a case adjacent to its position\n[Remove a tile] : remove a tile on a case adjacent to its position\n[Swap a tile] : swap a tile between 2 players\n[Skip turn] : simply skip your turn")
    
    print("\nThe effect of storm cards are the followings:\n[Vent Tourne Horaire] : change the wind direction clockwise\n[Vent Tourne Anti-Horaire] : change the wind direction counter clockwise\n[Eclair] : remove 1 HP of deadline\n[Bourasque] : push all player (1 case) in the wind direction\n[Orage se dechaine] : increase by 1 the storm gauge\n[Orage se dechaine + Melange pile]: same + remix all storm cards")
    
    print("\n\nPress [ENTER] to begin the game !")
    let _ = readLine()
    
    print("\nThe initial board :")
}


func beginGame(numberPlayer: Int, player1: Player, player2: Player, player3: Player, player4: Player, objective: [String], boardCase: [String], boardPos: [String], posPlayer: [Int], boardInstruction: [String], instrPlayer: [String], boardLock: [String], H: Int, W: Int, bd: inout Bool) {
    let arrayAllPlayers = [player1, player2, player3, player4]
    var turnPlayer = Int.random(in: 0...numberPlayer-1)
    var tmpListTiles = objective
    var visibleTiles = 3
    var tmpBoardPos = boardPos
    var tmpBoardCase = boardCase
    var tmpPosPlayer = posPlayer
    var tmpBoardInstruction = boardInstruction
    var tmpInstrPlayer = instrPlayer
    var tmpBoardLock = boardLock
    // Stop the game
    var gameFinished = false
    var countTurn = 0
    var deadline = 25
    
    // storm stack : cards depends of number of player ?? -- REMOVE EQUIP
    // initialisation of the stack
    let gameStack = Card(stormStack: [], equipStack: [], jaugeStorm: Double(5-numberPlayer))
    gameStack.stormStack.append(contentsOf: [eclair, eclair, eclair, bourasque, bourasque, bourasque, bourasque, ventTourneHoraire, ventTourneAntiHoraire, dechainement, dechainement, dechainement2])
    gameStack.stormStack.shuffle()
    
    // for testing
    //gameStack.stormStack[2] = "Bourasque"
    //gameStack.stormStack[3] = "Bourasque"
    
    // definition of the needle
    var needle = "→"
    
    // define if press action "Skip turn"
    var skipTurn = false
    // for the display of the beginning of the game
    bd = false
    
    while gameFinished != true {
        countTurn += 1
        // One entire turn decrease deadline which is global for all players
        if (countTurn == numberPlayer) {
            deadline -= 1
            countTurn = 0
        }
        if (deadline == 0) {
            gameFinished = true
            print("The deadline is over !\nGAME OVER")
        } else {
            print("The deadline: ", deadline)
            print("\nTURN OF PLAYER \(arrayAllPlayers[turnPlayer].id+1) : \(arrayAllPlayers[turnPlayer].nom)")
            let nbActionPerPlayer = 4
            for numAct in 0...nbActionPerPlayer-1 {
                // display storm cards incoming
                print("\nThe next storm cards are :", terminator: "")
                for card in 0...4 {
                 print(" -> [\(gameStack.stormStack[card])]", terminator: "")
                }
                print(" -> ...")
                
                // display wind direction
                print("The wind direction is: ", needle)
                print("\nACTION NUMBER: \(numAct+1)")
                var res = Actions.actionPlayer(currentPlayer: arrayAllPlayers[turnPlayer], arrayP: arrayAllPlayers, nbP: numberPlayer, listTiles: &tmpListTiles, nbVisibleTiles: &visibleTiles, boardCase: &tmpBoardCase, boardPos: &tmpBoardPos, posPlayer: &tmpPosPlayer, boardInstruction: &tmpBoardInstruction, instrPlayer: &tmpInstrPlayer, boardLock: &tmpBoardLock, H: H, W: W, skipTurn: &skipTurn)
                if (skipTurn == true) {
                    skipTurn = false
                    break
                }
                let _ = Display.displayBoard(boardInit: &res.2, displayPos: &res.3, displayInstruction: &res.5, H: H, W: W, posPlayer: &res.4, instrPlayer: &res.6, displayLock: &res.7, bd: &bd)
            }
            
        }
        
        // action storm stack
        let nbCardPerJauge = Int(ceil(gameStack.jaugeStorm/5))
        let changeCardsStorm = gameStack.stormStack.prefix(nbCardPerJauge)
        gameStack.stormStack.removeFirst(nbCardPerJauge)
        gameStack.stormStack += changeCardsStorm
        
        for changeCards in 0...changeCardsStorm.count-1 {
            // case of "Orage se dechaine"
            if (changeCardsStorm[changeCards] == dechainement) {
                gameStack.actionDechaine(objStack: gameStack)
            }
            // case of "Orage se dechaine + Melange"
            if (changeCardsStorm[changeCards] == dechainement2) {
                gameStack.actionDechaineMel(objStack: gameStack)
            }
            // case of "Eclair"
            if (changeCardsStorm[changeCards] == eclair) {
                gameStack.actionEclair(currentDeadLine: &deadline)
            }
            // case of "Vent Tourne Horaire"
            if (changeCardsStorm[changeCards] == ventTourneHoraire) {
                gameStack.actionVentTourneHoraire(needle: &needle)
            }
            // case of "Vent Tourne Anti-Horaire"
            if (changeCardsStorm[changeCards] == ventTourneAntiHoraire) {
                gameStack.actionVentTourneAntiHoraire(needle: &needle)
            }
            // case of "Bourasque"
            if (changeCardsStorm[changeCards] == bourasque) {
                gameStack.actionBourasque(nbPlayer: numberPlayer, arrayPlayer: arrayAllPlayers, boardCase: tmpBoardCase, boardPos: &tmpBoardPos, posPlayer: &tmpPosPlayer, boardInstruction: tmpBoardInstruction, W: W, H: H, needle: needle, deadline: &deadline)
            }
        }
        let _ = Display.displayBoard(boardInit: &tmpBoardCase, displayPos: &tmpBoardPos, displayInstruction: &tmpBoardInstruction, H: H, W: W, posPlayer: &tmpPosPlayer, instrPlayer: &tmpInstrPlayer, displayLock: &tmpBoardLock, bd: &bd)
        
        turnPlayer = (turnPlayer + 1) % numberPlayer
    }
}

func main(nombreLine: Int, nombreCol: Int) {
    // Get informations of players - number - name
    var infoPlayers = welcome()
    
    let center = (nombreLine*nombreCol)/2
    // Initialisation of players
    let J1 = Player(id: 0, nom: infoPlayers.1[0], cartes: [], position: center, equip: [])
    let J2 = Player(id: 1, nom: infoPlayers.1[1], cartes: [], position: center, equip: [])
    let J3 = Player(id: 2, nom: infoPlayers.1[2], cartes: [], position: center, equip: [])
    let J4 = Player(id: 3, nom: infoPlayers.1[3], cartes: [], position: center, equip: [])
    
    let tmpArrayPosPlayer = [J1.position, J2.position, J3.position, J4.position]
    var arrayPosPlayer: [Int] = []
    for i in 0...infoPlayers.0-1 {
        arrayPosPlayer.append(tmpArrayPosPlayer[i])
    }
    
    var arrayInstructionPlayer: [String] = []
    
    var beginDispl = true
    // Display rules for players
    displayRules()
    
    // Initialise the board
    var boardd = Array(repeating: "0", count: nombreLine*nombreCol)
    var boardP = Array(repeating: "", count: nombreLine*nombreCol)
    var boardI = Array(repeating: "", count: nombreLine*nombreCol)
    boardI[center] = "∆ - ROCKET - ∆ "
    var boardL = Array(repeating: "", count: nombreLine*nombreCol)
    let resDisplay = Display.displayBoard(boardInit: &boardd, displayPos: &boardP, displayInstruction: &boardI, H: nombreLine, W: nombreCol, posPlayer: &arrayPosPlayer, instrPlayer: &arrayInstructionPlayer, displayLock: &boardL, bd: &beginDispl)
    
    // Initialise objective - set of tiles
    var listTiles: [String] = []
    var listObjectives: [[String]] = []
    
    // add empty tiles
    var emptyTiles: [String] = []
    for _ in 0...(infoPlayers.0)*3 {
        emptyTiles.append("_")
    }
    
    listObjectives.append(objective_countdown)
    listObjectives.append(objective_ckeckTeam)
    listObjectives.append(objective_checkFuel)
    listObjectives.append(objective_autoPilot)
    listObjectives.append(objective_checkTask)
    listObjectives.append(objective_checkEngine)
    
    // Select random objectives depends of the number of players
    for _ in 0...infoPlayers.0-1 {
        let randObj = Int.random(in: 0...(listObjectives.count-1))
        listTiles += listObjectives[randObj]
        listObjectives.remove(at: randObj)
    }
    
    // All tiles available for the game (concatenation of objectives)
    print("\nlist of Tiles for this game: --> \(listTiles)\n")
    
    // Duplication of the tiles implies don't need the whole tiles to win the game ??
    //listTiles += listTiles
    
    // insert empty tiles
    listTiles += emptyTiles

    // Start the game
    beginGame(numberPlayer: infoPlayers.0, player1: J1, player2: J2, player3: J3, player4: J4, objective: listTiles, boardCase: resDisplay.0, boardPos: resDisplay.1, posPlayer: resDisplay.2, boardInstruction: resDisplay.5, instrPlayer: resDisplay.6, boardLock: resDisplay.7, H: resDisplay.3, W: resDisplay.4, bd: &beginDispl)
}

// Start program
main(nombreLine: 7, nombreCol: 9)
