import UIKit

extension GraffeineAnimation.Data.Pie {

    public struct Morph: GraffeinePieDataAnimating {

        let equalizeAngles = GraffeineAnimation.Data.Pie.equalizeAngles

        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName

        public init(duration: TimeInterval, timing: CAMediaTimingFunctionName) {
            self.duration = duration
            self.timing = timing
        }

        public func animate(pieSlice: GraffeinePieLayer.PieSlice, fromAngles: GraffeineAnglePair, toAngles: GraffeineAnglePair, centerPoint: CGPoint) {

            let fromPath = pieSlice.presentation()?.path
                ?? pieSlice.constructPath(centerPoint: centerPoint, angles: fromAngles)
            let toPath = pieSlice.constructPath(centerPoint: centerPoint, angles: toAngles)

            let animation = CABasicAnimation(keyPath: "path")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.fromValue = fromPath
            animation.toValue = toPath
            pieSlice.path = toPath
            pieSlice.add(animation, forKey: "GraffeineAnimation.Data.Pie.Morph")
        }
    }
}
