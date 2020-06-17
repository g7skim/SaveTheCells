/*
IconsSet.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import Foundation
struct IconsSet {
    let cell: String
    let house: String
}

enum PlayMode {
    case CellPink
    case CellBlue
    case CellYellow
    case CellPinkH
    case CellBlueH
    case CellYellowH

    func icons() -> IconsSet {
        let home = "HomeBlock"
        switch self {
        case .CellPink: return IconsSet(cell: "CellPink", house: home)
        case .CellBlue: return IconsSet(cell: "CellBlue", house: home)
        case .CellYellow: return IconsSet(cell: "CellYellow", house: home)
        case .CellPinkH: return IconsSet(cell: "CellPinkH", house: home)
        case .CellBlueH: return IconsSet(cell: "CellBlueH", house: home)
        case .CellYellowH: return IconsSet(cell: "CellYellowH", house: home)
        }
    }
}
