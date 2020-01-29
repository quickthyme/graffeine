import UIKit

public protocol GraffeinePieLabelDataAnimating: GraffeineDataAnimating {
    func animate(label: GraffeinePieLabelLayer.Label,
                 fromAngles: GraffeineAnglePair,
                 toAngles: GraffeineAnglePair,
                 labelPoint: CGPoint,
                 centerPoint: CGPoint)
}

extension GraffeineAnimation.Data {

    public struct PieLabel {
        private init() {}
    }
}
