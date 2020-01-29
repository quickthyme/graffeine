import UIKit

extension GraffeineAnimation.Data.RadialSegment {

    public struct Automatic: GraffeineRadialSegmentDataAnimating {

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
            pieSlice.add(animation, forKey: "GraffeineAnimation.Data.RadialSegment.Automatic")
        }

        private func interpolatePaths(pieSlice: GraffeineRadialSegmentLayer.Segment,
                                      fromAngles: GraffeineAnglePair,
                                      toAngles: GraffeineAnglePair,
                                      centerPoint: CGPoint) -> [CGPath] {
            let startStep: CGFloat = (fromAngles.start < toAngles.start) ? HalfDegreeInRadians : -HalfDegreeInRadians
            let endStep: CGFloat = (fromAngles.end < toAngles.end) ? HalfDegreeInRadians : -HalfDegreeInRadians
            let eqAngles = equalizeAngles(
                [fromAngles.start]
                    + Array<CGFloat>(stride(from: fromAngles.start,
                                            to: toAngles.start,
                                            by: startStep))
                    + [toAngles.start],
                [fromAngles.end]
                    + Array<CGFloat>(stride(from: fromAngles.end,
                                            to: toAngles.end,
                                            by: endStep))
                    + [toAngles.end]
            )

            return zip(eqAngles.start, eqAngles.end).map {
                return pieSlice.constructPath(centerPoint: centerPoint,
                                              angles: GraffeineAnglePair(start: $0.0, end: $0.1))
            }
        }
    }
}
