import UIKit

extension GraffeineAnimation.Data.RadialSegment {

    public struct Morph: GraffeineRadialSegmentDataAnimating {

        let equalizeAngles = GraffeineAnimation.Data.RadialSegment.equalizeAngles

        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName

        public init(duration: TimeInterval, timing: CAMediaTimingFunctionName) {
            self.duration = duration
            self.timing = timing
        }

        public func animate(pieSlice: GraffeineRadialSegmentLayer.Segment,
                            fromAngles: GraffeineAnglePair,
                            toAngles: GraffeineAnglePair,
                            centerPoint: CGPoint) {

            let fromPath = pieSlice.presentation()?.path
                ?? pieSlice.constructPath(centerPoint: centerPoint, angles: fromAngles)
            let toPath = pieSlice.constructPath(centerPoint: centerPoint, angles: toAngles)

            let animation = CABasicAnimation(keyPath: "path")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.fromValue = fromPath
            animation.toValue = toPath
            pieSlice.path = toPath
            pieSlice.add(animation, forKey: "GraffeineAnimation.Data.RadialSegment.Morph")
        }
    }
}
