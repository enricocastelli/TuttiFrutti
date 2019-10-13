//
//  Extension.swift
//  TuttiFrutti
//
//  Created by Enrico Castelli on 13/10/2019.
//  Copyright © 2019 EC. All rights reserved.
//

import Foundation

extension Array where Element == Card {
    
    mutating func update(_ card: Card, index: Int) {
        self.remove(at: index)
        self.insert(card, at: index)
    }
}
