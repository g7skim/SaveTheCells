/*
SKSpriteNodeExtensions.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import SpriteKit
extension SKSpriteNode {

    func aspectFitToSize(_ fitSize: CGSize) {
        guard let texture = texture else { return }

        size = texture.size()
        let verticalRatio = fitSize.height / texture.size().height
        let horizontalRatio = fitSize.width /  texture.size().width
        let scaleRatio = min(verticalRatio, horizontalRatio)

        self.setScale(scaleRatio)
    }

    func scaleToFit(size: CGSize, texture: SKTexture, offset: CGFloat = 0) -> CGFloat {
        let verticalRatio = (size.height - offset) / texture.size().height
        let horizontalRatio = (size.width - offset) / texture.size().width
        let scaleRatio = min(verticalRatio, horizontalRatio)
        return scaleRatio
    }

    func aspectFillToSize(fillSize: CGSize) {

        if texture != nil {
            self.size = texture!.size()

            let verticalRatio = fillSize.height / self.texture!.size().height
            let horizontalRatio = fillSize.width /  self.texture!.size().width

            let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio

            self.setScale(scaleRatio)
        }
    }


}
