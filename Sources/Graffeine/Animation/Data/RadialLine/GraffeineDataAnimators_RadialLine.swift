import UIKit

public protocol GraffeineRadialLineDataAnimating: GraffeineDataAnimating {
    func animate(line: GraffeineRadialLineLayer.Line,
                 fromAngles: GraffeineAnglePair,
                 toAngles: GraffeineAnglePair,
                 outerPoint: CGPoint,
                 innerPoint: CGPoint)
}

extension GraffeineAnimation.Data {

    public struct RadialLine {
        private init() {}
    }
}
