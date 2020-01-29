import UIKit

extension GraffeineAnimation.Data.RadialSegment {

    public struct Spin: GraffeineRadialSegmentDataAnimating {

        let equalizeAngles = GraffeineAnimation.Data.RadialSegment.equalizeAngles

        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName

        public init(duration: TimeInterval, timing: CAMediaTimingFunctionName) {
            self.duration = duration
            self.timing = timing
        }

        public func animate(pieSlice: GraffeineRadialSegmentLayer.Segment, fromAngles: GraffeineAnglePair, toAngles: GraffeineAnglePair, centerPoint: CGPoint) {
            let animation = CAKeyframeAnimation(keyPath: "path")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.values = interpolatePaths(pieSlice: pieSlice,
                                                fromAngles: fromAngles,
                                                toAngles: toAngles,
                                                centerPoint: centerPoint)
            pieSlice.path = pieSlice.constructPath(centerPoint: centerPoint, angles: toAngles)
            pieSlice.add(animation, forKey: "GraffeineAnimation.Data.RadialSegment.Spin")
        }

        private func interpolatePaths(pieSlice: GraffeineRadialSegmentLayer.Segment,
                                      fromAngles: GraffeineAnglePair,
                                      toAngles: GraffeineAnglePair,
                                      centerPoint: CGPoint) -> [CGPath] {
            let startStep: CGFloat = HalfDegreeInRadians
            let endStep: CGFloat = HalfDegreeInRadians
            let fullCircle = DegreesToRadians(360)

            let eqAngles1 = equalizeAngles(
                [fromAngles.start]
                    + Array<CGFloat>(stride(from: fromAngles.start,
                                            to: fullCircle,
                                            by: startStep))
                    + [fullCircle],
                [fromAngles.end]
                    + Array<CGFloat>(stride(from: fromAngles.end,
                                            to: fullCircle,
                                            by: endStep))
                    + [fullCircle]
            )

            let eqAngles2 = equalizeAngles(
                [CGFloat(0)]
                    + Array<CGFloat>(stride(from: CGFloat(0),
                                            to: toAngles.start,
                                            by: startStep))
                    + [toAngles.start],
                [CGFloat(0)]
                    + Array<CGFloat>(stride(from: CGFloat(0),
                                            to: toAngles.end,
                                            by: endStep))
                    + [toAngles.end]
            )

            return zip(eqAngles1.start + eqAngles2.start, eqAngles1.end + eqAngles2.end).map {
                return pieSlice.constructPath(centerPoint: centerPoint,
                                              angles: GraffeineAnglePair(start: $0.0, end: $0.1))
            }
        }
    }
}
