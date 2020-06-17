/*
Placement.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import Foundation
struct Placement: Equatable {
    let horizontal: Int
    let vertical: Int

    func canBeAchived(from placement: Placement) -> Bool {
        let farNeighbors = horizontal == placement.horizontal || vertical == placement.vertical
        let nearNeighbors = (abs(horizontal - placement.horizontal) <= 1) && (abs(vertical - placement.vertical) <= 1)
        return nearNeighbors && farNeighbors
    }

    func findConnector(to placement: Placement) -> Placement {
        return Placement(horizontal: horizontal, vertical: placement.vertical)
    }

    func site(between placement: Placement) -> [Placement] {
        let siteFirst = Placement(horizontal: horizontal, vertical: placement.vertical)
        let siteSecond = Placement(horizontal: placement.horizontal, vertical: vertical)
        return [siteFirst, siteSecond]
    }

    static func random(in platform: Platform) -> Placement {
        let horizontal = Int.random(in: 0 ..< platform.horizontals)
        let vertical = Int.random(in: 0 ..< platform.verticals)
        return Placement(horizontal: horizontal, vertical: vertical)
    }

    static func == (lhs: Placement, rhs: Placement) -> Bool {
        return (lhs.vertical == rhs.vertical) && (rhs.horizontal == lhs.horizontal)
    }

    static func > (lhs: Placement, rhs: Placement) -> Bool {
        if lhs.horizontal > rhs.horizontal {
            return true
        } else {
            return lhs.vertical > rhs.vertical
        }
    }
}
