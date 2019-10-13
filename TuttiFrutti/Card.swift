//
//  Card.swift
//  TuttiFrutti
//
//  Created by Enrico Castelli on 13/10/2019.
//  Copyright © 2019 EC. All rights reserved.
//

import Foundation

struct Card {
    var name: String
    var power: Int
    var angles: [Direction] = []
    var isUser: Bool = true
    var points = 0
    
    init(name: String, power: Int) {
        self.name = name
        self.power = power
        self.angles = getAngles()
    }
    
    static func array() -> [Card] {
        return [Card(name: "Pineapple", power: 2),
                Card(name: "Cherry", power: 2),
                Card(name: "Orange", power: 1),
                Card(name: "Banana", power: 1),
                Card(name: "Strawberry", power: 3),
                Card(name: "Watermelon", power: 2)
        ]
    }
    
    static func getRandomDeck() -> [Card] {
        return [array().randomElement()!,
                array().randomElement()!,
                array().randomElement()!,
                array().randomElement()!]
    }
    
    static func getRandom() -> Card {
        return array().randomElement()!
    }
    
    func isEmpty() -> Bool {
        return name == ""
    }
    
    private func getAngles() -> [Direction] {
        var arr = [Direction]()
        for _ in 0...power {
            arr.append(Direction.getRandom())
        }
        return arr
    }
}

enum Direction: CaseIterable{
    
    case N
    case NE
    case E
    case SE
    case S
    case SW
    case W
    case NW
    
    func intValue() -> Int {
        switch self {
        case .N: return 1
        case .NE: return 2
        case .E: return 4
        case .SE:return 7
        case .S: return 6
        case .SW: return 5
        case .W: return 3
        case .NW:return 0
        }
    }
    
    static func getRandom() -> Direction {
        return Direction.allCases.randomElement()!
    }
}
