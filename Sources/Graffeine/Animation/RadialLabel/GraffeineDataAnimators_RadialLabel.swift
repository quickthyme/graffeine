import UIKit

public protocol GraffeineRadialLabelDataAnimating: GraffeineDataAnimating {
    func animate(label: GraffeineRadialLabelLayer.Label,
                 fromAngles: GraffeineAnglePair,
                 toAngles: GraffeineAnglePair,
                 labelPoint: CGPoint,
                 centerPoint: CGPoint)
}

extension GraffeineDataAnimators {

    public struct RadialLabel {
        private init() {}
    }
}
