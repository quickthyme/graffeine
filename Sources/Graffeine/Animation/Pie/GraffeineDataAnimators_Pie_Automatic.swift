import UIKit

extension GraffeineDataAnimators.Pie {

    public struct Automatic: GraffeinePieDataAnimating {

        let equalizeAngles = GraffeineDataAnimators.Pie.equalizeAngles

        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName

        public init(duration: TimeInterval, timing: CAMediaTimingFunctionName) {
            self.duration = duration
            self.timing = timing
        }

        public func animate(pieSlice: GraffeinePieLayer.PieSlice, fromAngles: GraffeineAnglePair, toAngles: GraffeineAnglePair, centerPoint: CGPoint) {
            let animation = CAKeyframeAnimation(keyPath: "path")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.values = interpolatePaths(pieSlice: pieSlice,
                                                fromAngles: fromAngles,
                                                toAngles: toAngles,
                                                centerPoint: centerPoint)
            pieSlice.path = pieSlice.constructPath(centerPoint: centerPoint, angles: toAngles)
            pieSlice.add(animation, forKey: "GraffeineDataAnimators.Pie.Automatic")
        }

        private func interpolatePaths(pieSlice: GraffeinePieLayer.PieSlice,
                                      fromAngles: GraffeineAnglePair,
                                      toAngles: GraffeineAnglePair,
                                      centerPoint: CGPoint) -> [CGPath] {
            let startStep: CGFloat = (fromAngles.start < toAngles.start) ? OneDegreeInRadians : -OneDegreeInRadians
            let endStep: CGFloat = (fromAngles.end < toAngles.end) ? OneDegreeInRadians : -OneDegreeInRadians
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
