//
//  File.swift
//  PokemonGetter
//
//  Created by Brian Sadler on 10/24/18.
//  Copyright © 2018 Brian Sadler. All rights reserved.
//

import Foundation

class Pokemon {
    var name: String
    var HP = 100
    var abilityNames: [String]
    

init(name: String, abilityNames: [String]) {
    self.name = name
    self.abilityNames = abilityNames
}
}
