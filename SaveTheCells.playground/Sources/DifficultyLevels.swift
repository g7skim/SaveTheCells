/*
DifficultyLevels.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import Foundation
public enum DifficultyLevels: String {
    case easy = "Easy - 3 cells to save"
    case medium = "Medium - 4 cells to save"
    case hard = "Hard - 5 cells to save"
    case insane = "Insane - 6 cells to save"

    func parameters() -> Parameters {
        switch self {
        case .easy:
            let platform = Platform(horizontals: 5, verticals: 5)
            let parameters = Parameters(prepareTime: 5, cellsInRound: 3, numberOfEnemies: 10, platform: platform)
            return parameters
            
        case .medium:
            let platform = Platform(horizontals: 6, verticals: 6)
            let parameters = Parameters(prepareTime: 4, cellsInRound: 4, numberOfEnemies: 12, platform: platform)
            return parameters
            
        case .hard:
            let platform = Platform(horizontals: 7, verticals: 7)
            let parameters = Parameters(prepareTime: 3, cellsInRound: 5, numberOfEnemies: 20, platform: platform)
            return parameters
            
        case .insane:
            let platform = Platform(horizontals: 10, verticals: 10)
            let parameters = Parameters(prepareTime: 3, cellsInRound: 6, numberOfEnemies: 60, platform: platform)
            return parameters
        }
    }
}
