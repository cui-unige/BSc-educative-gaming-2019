//
//  main.swift
//  SeriousGame
//
//  Created by cui on 29.03.19.
//  Copyright © 2019 cui. All rights reserved.
//

import Foundation

// define color for theme
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

let Display = Board()
let Actions = Action()

// define number of players max
let maxPlayer = 4

// definition of storm cards
let eclair = "Storm"
let bourasque = "Squall"
let ventTourneHoraire = "Wind turn clockwise"
let ventTourneAntiHoraire = "Wind turn counter cw"
let dechainement = "Storm rages on"
let dechainement2 = "Storm rages on & shuffle"


// definition of objectives
let objective_countdown: [String] = ["BEGIN", "[VAR] = 10", "WHILE", "[VAR] != 0", "SHOW([VAR])", "[VAR] = [VAR]-1", "ENDWHILE", "END", "BEGIN", "FOR", "[VAR] = 10 TO 0", "SHOW([VAR])", "ENDFOR", "END"]
let objective_ckeckTeam: [String] = ["BEGIN", "[VAR] = FALSE", "NB_T != LEN(T)", "[VAR] = TRUE", "ENDWHILE", "END", "BEGIN", "IF", "NB_T == LEN(T)", "ENDIF", "END"]

// FIXME:
/*
let objective_checkFuel: [String] = ["BEGIN", "if", "fuel", ">= (d_l/c_f)*2", "check()", "else", "while", "cur_fuel", "!= fuel", "fill", "END"]
let objective_autoPilot: [String] = ["BEGIN", "if", "cur_dist", "<= (1/3)*d_lune", "s = take_off", "else if", "cur_dist", "> (2/3)*d_lune", "s = landing", "else", "s = fly", "END"]
let objective_checkTask: [String] = ["BEGIN", "for", "i in list", "if", "check(i)", "== true", "continue", "else", "check(i) == true", "END"]
let objective_checkEngine: [String] = ["BEGIN", "if", "temp", "> right_temp", "check()", "else", "while", "temp", "!= right_temp", "warm()", "check()", "END"]
*/


// ask number of players in the game
// return an array which contains player's name
func askNamePlayer(numPlayers: Int) -> [String] {
    var arrayPlayer = Array(repeating: "", count: maxPlayer)
    for players in 0...numPlayers-1 {
        print("Name of player \(players+1): ", terminator: "")
        let namePlayer = readLine()
        arrayPlayer[players] = namePlayer!
    }
    return arrayPlayer
}

// display entering the game
// get the number of players in the game
func welcome() -> (nbP: Int, [String]) {
    print("WELCOME TO SPACE ENCODERS\n")
    print("\(color)0\(blue)ENTER THE NUMBER OF PLAYER (2-4)\(color)0\(none): ", terminator: "")
    let nbPlayer = readLine()!
    let enumPlayer = askNamePlayer(numPlayers: Int(nbPlayer)!)
    return (Int(nbPlayer)!, enumPlayer)
}

// display rules and goals of the game
// ask to press [enter] to continue and display the initial board
func displayRules() {
    print("\n\(color)0\(red)GOALS\(color)0\(none):")
    print("The goal of this game is to create several algorithms with tiles in order to allow the rocket to take off. The tiles must be well connected !\nThis game is based on cooperation so you are advised to play with your allies !\nBut be careful, you have to be fast enough to build everything before the end of time !")
    
    print("\n\(color)0\(red)RULES\(color)0\(none):")
    print("Firsty every player begin in the center of the map (in the same case of the Rocket).\nThe algorithms to build are selected randomly (number of player = number of algorithms to build) ! Each turn, each player can do 4 actions or less.\nHe has the choice between : (1) Draw a card, (2) Move on the map, (3) Explore the map, (4) Remove a tile, (5) Swap a tile, (6) Skip turn.\nMoreover there are several unforeseen during the game : The storm cards. It happend every end of turn of a player !\nThe more the gauge is high, the more storm cards are applied !\nWhen every algorithms are well constructed before the end of the deadline and if every player are in the center, the game is win !")
    
    print("\nThe effect of action are the followings:\n\(color)0\(cyan)[Draw a tile]\(color)0\(none) : choose a tile from the draw stack\n\(color)0\(cyan)[Move on the map]\(color)0\(none) : move on tiles\n\(color)0\(cyan)[Explore the map]\(color)0\(none) : place a tile on a case adjacent to its position\n\(color)0\(cyan)[Remove a tile]\(color)0\(none) : remove a tile on a case adjacent to its position\n\(color)0\(cyan)[Swap a tile]\(color)0\(none) : swap a tile between 2 players\n\(color)0\(cyan)[Skip turn] \(color)0\(none): simply skip your turn")
    
    print("\nThe effect of storm cards are the followings:\n\(color)0\(magenta)[Wind Turn clockwise]\(color)0\(none) : change the wind direction clockwise\n\(color)0\(magenta)[Wind turn counter cw] \(color)0\(none): change the wind direction counter clockwise\n\(color)0\(magenta)[Storm]\(color)0\(none) : remove 1 HP of deadline\n\(color)0\(magenta)[Squall] \(color)0\(none): push all player (1 case) in the wind direction\n\(color)0\(magenta)[Storm rages on] \(color)0\(none): increase by 1 the storm gauge\n\(color)0\(magenta)[Storm rages on & shuffle] \(color)0\(none): same + remix all storm cards")
    
    print("\n\(color)3\(red)You can find the whole goals and rules in the file [goalsNrules]\(color)0\(none)")
    print("\n\(color)3\(red)You can also find the algorithms in the file [objectives]\(color)0\(none)")
    
    print("\n\nPress \(color)0\(red)[ENTER]\(color)0\(none) to begin the game !")
    let _ = readLine()
    
    print("\nThe initial board :")
}

// main function for the progress of the game
// set the main variables and constantes
func beginGame(numberPlayer: Int, player1: Player, player2: Player, player3: Player, player4: Player, objective: [String], boardCase: [String], boardPos: [String], posPlayer: [Int], boardInstruction: [String], instrPlayer: [String], boardLock: [String], H: Int, W: Int, bd: inout Bool) {
    
    let arrayAllPlayers = [player1, player2, player3, player4]
    var turnPlayer = 0
    var tmpListTiles = objective
    var visibleTiles = 3
    var tmpBoardPos = boardPos
    var tmpBoardCase = boardCase
    var tmpPosPlayer = posPlayer
    var tmpBoardInstruction = boardInstruction
    var tmpInstrPlayer = instrPlayer
    var tmpBoardLock = boardLock
    var gameFinished = false
    var countTurn = 0
    var deadline = 25
    
    // initialisation of the storm stack
    // fill it and apply a shuffle
    let gameStack = Card(stormStack: [], equipStack: [], jaugeStorm: Double(numberPlayer-1))
    gameStack.stormStack.append(contentsOf: [eclair, eclair, eclair, bourasque, bourasque, bourasque, bourasque, ventTourneHoraire, ventTourneAntiHoraire, dechainement, dechainement, dechainement2])
    gameStack.stormStack.shuffle()
    
    // define of the needle
    // define variables relating to the storm gauge
    var needle = "→"
    var nbCardPerJauge: Int
    var jaugeBar: String
    
    // the gauge takes different values depending on the number of players
    switch numberPlayer {
    case 2:
        jaugeBar = String(repeating: "-", count: 3*2-1)
        jaugeBar += "\(color)0\(red)↑\(color)0\(none)"
    case 3:
        jaugeBar = String(repeating: "-", count: 2*2-1)
        jaugeBar += "\(color)0\(red)↑\(color)0\(none)"
    case 4:
        jaugeBar = String(repeating: "-", count: 1*2-1)
        jaugeBar += "\(color)0\(red)↑\(color)0\(none)"
    default:
        jaugeBar = ""
        print("ERROR DEV")
    }
    
    // define a flag relating to the action "Skip turn"
    var skipTurn = false
    // variables for the display at the beginning of the game
    bd = false
    
    // for loops to fill hands of players at the begining
    print("\n\(color)1\(green)Every player have to fill his hand with 5 tiles\(color)0\(none)\n")
    for players in 0...numberPlayer-1 {
        print("\(color)1\(cyan)Selection menu for \(arrayAllPlayers[players].nom):\(color)0\(none)")
        var tabLog = Array(repeating: "", count: 5)
        var c = 0
        for _ in 0...4 {
            // call the action "Draw a card"
            let resFill = Actions.drawACard(currentPlayer: arrayAllPlayers[players], listTiles: &tmpListTiles, nbVisibleTiles: &visibleTiles)
            tmpListTiles = resFill.1
            tabLog[c] = resFill.2
            c += 1
        }
        print("\n\(color)1\(cyan)Result of the selection: \(color)1\(none)")
        for i in 0...4 {
            print("\(color)0\(green)\(tabLog[i])", terminator: "")
        }
        print("\(color)0\(none)\n")
    }
    
    // while loop until the game is not finish
    // it stops when deadline == 0 or when the players win
    while gameFinished != true {
        countTurn += 1
        // one entire turn decrease deadline which is global for all players
        if (countTurn == numberPlayer) {
            deadline -= 1
            countTurn = 0
        }
        if (deadline == 0) {
            gameFinished = true
            print("The deadline is over !\nGAME OVER")
        } else {
            print("\(color)1\(red)The deadline: ", deadline)
            print("\(color)1\(none)\nTURN OF PLAYER \(arrayAllPlayers[turnPlayer].id+1) : \(arrayAllPlayers[turnPlayer].nom)")
            // define number of actions for each player, each turn
            let nbActionPerPlayer = 4
            for numAct in 0...nbActionPerPlayer-1 {
                // display storm cards incoming
                print("\nThe next storm cards are :", terminator: "")
                for card in 0...4 {
                 print(" → [\(gameStack.stormStack[card])]", terminator: "")
                }
                print(" → ...")
                
                // display wind direction
                print("The wind direction is: ", needle)
                // displayer the storm gauge
                print("The storm gauge:\n")
                print("1    2        3        4      5    \(color)0\(red)X\(color)0\(none)")
                print(jaugeBar)
                // display the menu to select an action
                print("\n\(color)1\(green)ACTIONS REMINING FOR PLAYER \(arrayAllPlayers[turnPlayer].id+1) (\(arrayAllPlayers[turnPlayer].nom)): \(4 - numAct)\(color)0\(none)")
                // call the main function in the class Action
                var res = Actions.actionPlayer(currentPlayer: arrayAllPlayers[turnPlayer], arrayP: arrayAllPlayers, nbP: numberPlayer, listTiles: &tmpListTiles, nbVisibleTiles: &visibleTiles, boardCase: &tmpBoardCase, boardPos: &tmpBoardPos, posPlayer: &tmpPosPlayer, boardInstruction: &tmpBoardInstruction, instrPlayer: &tmpInstrPlayer, boardLock: &tmpBoardLock, H: H, W: W, skipTurn: &skipTurn)
                // check the flag if the player want to skip his turn
                if (skipTurn == true) {
                    skipTurn = false
                    // display the board
                    let _ = Display.displayBoard(boardInit: &res.2, displayPos: &res.3, displayInstruction: &res.5, H: H, W: W, posPlayer: &res.4, instrPlayer: &res.6, displayLock: &res.7, bd: &bd)
                    print("\(color)3\(red)You can see objectives in the file [objectives]\(color)0\(none)\n")
                    // display the log
                    print("\(color)0\(cyan)Result of your action: \(color)0\(none)\n",res.9)
                    break
                }
                // same but the board is updated by the result of the action
                let _ = Display.displayBoard(boardInit: &res.2, displayPos: &res.3, displayInstruction: &res.5, H: H, W: W, posPlayer: &res.4, instrPlayer: &res.6, displayLock: &res.7, bd: &bd)
                print("\(color)3\(red)You can see objectives in the file [objectives]\(color)0\(none)\n")
                
                print("\(color)0\(cyan)Result of your action: \(color)0\(none)\n",res.9)
            }
            
        }
        
        // change the current player
        turnPlayer = (turnPlayer + 1) % numberPlayer
        
        // action storm stack
        // the number of cards which have to be executed depends of the value of the storm gauge
        if (turnPlayer == 0) {
            if (1...2 ~= gameStack.jaugeStorm) {
                nbCardPerJauge = 1
            } else if (3...7 ~= gameStack.jaugeStorm) {
                nbCardPerJauge = 2
            } else if (8...12 ~= gameStack.jaugeStorm) {
                nbCardPerJauge = 3
            } else if (13...16 ~= gameStack.jaugeStorm) {
                nbCardPerJauge = 4
            } else if (17...19 ~= gameStack.jaugeStorm) {
                nbCardPerJauge = 5
            } else {
                nbCardPerJauge = 6
                deadline = 0
            }
        
            // retrieve the cards and put them under the stack
            let changeCardsStorm = gameStack.stormStack.prefix(nbCardPerJauge)
            gameStack.stormStack.removeFirst(nbCardPerJauge)
            gameStack.stormStack += changeCardsStorm
        
            // define the log for the storm cards
            var logStormCards: String = ""
        
            // call cards action
            for changeCards in 0...changeCardsStorm.count-1 {
                // case of "Orage se dechaine" -> storm rages on
                if (changeCardsStorm[changeCards] == dechainement) {
                    gameStack.actionDechaine(objStack: gameStack, log: &logStormCards)
                }
                // case of "Orage se dechaine + Melange" -> storm rages on shuffle
                if (changeCardsStorm[changeCards] == dechainement2) {
                    gameStack.actionDechaineMel(objStack: gameStack, log: &logStormCards)
                }
                // case of "Eclair" -> storm
                if (changeCardsStorm[changeCards] == eclair) {
                    gameStack.actionEclair(currentDeadLine: &deadline, log: &logStormCards)
                }
                // case of "Vent Tourne Horaire" -> wind turn clockwise
                if (changeCardsStorm[changeCards] == ventTourneHoraire) {
                    gameStack.actionVentTourneHoraire(needle: &needle, log: &logStormCards)
                }
                // case of "Vent Tourne Anti-Horaire" -> wind turn count cw
                if (changeCardsStorm[changeCards] == ventTourneAntiHoraire) {
                    gameStack.actionVentTourneAntiHoraire(needle: &needle, log: &logStormCards)
                }
                // case of "Bourasque" -> squall
                if (changeCardsStorm[changeCards] == bourasque) {
                    gameStack.actionBourasque(nbPlayer: numberPlayer, arrayPlayer: arrayAllPlayers, boardCase: tmpBoardCase, boardPos: &tmpBoardPos, posPlayer: &tmpPosPlayer, boardInstruction: tmpBoardInstruction, W: W, H: H, needle: needle, deadline: &deadline, log: &logStormCards)
                }
            }
        
            // update the gauge storm
            jaugeBar = String(repeating: "-", count: Int(gameStack.jaugeStorm)*2-1)
            jaugeBar += "\(color)0\(red)↑\(color)0\(none)"
            
            // display the board to see updates
            let _ = Display.displayBoard(boardInit: &tmpBoardCase, displayPos: &tmpBoardPos, displayInstruction: &tmpBoardInstruction, H: H, W: W, posPlayer: &tmpPosPlayer, instrPlayer: &tmpInstrPlayer, displayLock: &tmpBoardLock, bd: &bd)
            print("\(color)3\(red)You can see objectives in the file [objectives]\(color)0\(none)")
            print("\n\(color)0\(cyan)Result of storm cards:\(color)0\(none)", logStormCards)
            print("\(color)1\(red)Scroll up to see the log of your last action\(color)0\(none)\n")
        }
    }
}

// main function
func main(nombreLine: Int, nombreCol: Int) {
    
    // get the basic terminal theme
    print("\(color)0\(none)")
    // get informations of players
    var infoPlayers = welcome()
    
    let center = (nombreLine*nombreCol)/2
    // initialisation of players (max 4)
    let J1 = Player(id: 0, nom: infoPlayers.1[0], cartes: [], position: center, equip: [])
    let J2 = Player(id: 1, nom: infoPlayers.1[1], cartes: [], position: center, equip: [])
    let J3 = Player(id: 2, nom: infoPlayers.1[2], cartes: [], position: center, equip: [])
    let J4 = Player(id: 3, nom: infoPlayers.1[3], cartes: [], position: center, equip: [])
    
    let tmpArrayPosPlayer = [J1.position, J2.position, J3.position, J4.position]
    var arrayPosPlayer: [Int] = []
    // get the initial position of the players
    for i in 0...infoPlayers.0-1 {
        arrayPosPlayer.append(tmpArrayPosPlayer[i])
    }
    
    var arrayInstructionPlayer: [String] = []
    
    var beginDispl = true
    // display rules for players
    displayRules()
    
    // initialise the several boards used for number of case, instruction in the case and position of players
    var boardd = Array(repeating: "0", count: nombreLine*nombreCol)
    var boardP = Array(repeating: "", count: nombreLine*nombreCol)
    var boardI = Array(repeating: "", count: nombreLine*nombreCol)
    boardI[center] = "∆ - ROCKET - ∆ "
    
    // FIXME: remove boardL
    var boardL = Array(repeating: "", count: nombreLine*nombreCol)
    let resDisplay = Display.displayBoard(boardInit: &boardd, displayPos: &boardP, displayInstruction: &boardI, H: nombreLine, W: nombreCol, posPlayer: &arrayPosPlayer, instrPlayer: &arrayInstructionPlayer, displayLock: &boardL, bd: &beginDispl)
    
    // initialise objective and the set of tiles
    var listTiles: [String] = []
    var listObjectives: [[String]] = []
    
    listObjectives.append(objective_countdown)
    listObjectives.append(objective_ckeckTeam)
    
    // FIXME: with defintion of objectives
    /*listObjectives.append(objective_checkFuel)
    listObjectives.append(objective_autoPilot)
    listObjectives.append(objective_checkTask)
    listObjectives.append(objective_checkEngine)*/
    
    // select random objectives depending of the number of players (nb algo = nb player -1)
    for _ in 0...infoPlayers.0-2 {
        let randObj = Int.random(in: 0...(listObjectives.count-1))
        listTiles += listObjectives[randObj]
        listObjectives.remove(at: randObj)
    }
    
    // add a proportionnal number of empty tiles
    var emptyTiles: [String] = []
    for _ in 0...(listTiles.count)/2 {
        emptyTiles.append("<< Empty >>")
    }
    
    // display all tiles available for the game which will duplicate in an auxilar file
    print("\nlist of Tiles for this game: --> \(listTiles)\n")
    print("\(color)3\(red)You can see objectives in the file [objectives]\(color)0\(none)\n")
    
    // insert the empty tiles
    listTiles += emptyTiles

    // start the game
    beginGame(numberPlayer: infoPlayers.0, player1: J1, player2: J2, player3: J3, player4: J4, objective: listTiles, boardCase: resDisplay.0, boardPos: resDisplay.1, posPlayer: resDisplay.2, boardInstruction: resDisplay.5, instrPlayer: resDisplay.6, boardLock: resDisplay.7, H: resDisplay.3, W: resDisplay.4, bd: &beginDispl)
}

// start the program
main(nombreLine: 7, nombreCol: 9)
