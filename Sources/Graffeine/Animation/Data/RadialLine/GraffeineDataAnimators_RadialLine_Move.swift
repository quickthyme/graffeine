import UIKit

extension GraffeineAnimation.Data.RadialLine {

    public struct Move: GraffeineRadialLineDataAnimating {

        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName

        public init(duration: TimeInterval = 0.8,
                    timing: CAMediaTimingFunctionName = .linear) {
            self.duration = duration
            self.timing = timing
        }

        public func animate(line: GraffeineRadialLineLayer.Line,
                            fromAngles: GraffeineAnglePair,
                            toAngles: GraffeineAnglePair,
                            outerPoint: CGPoint,
                            innerPoint: CGPoint) {

            let fromPath = line.presentation()?.path
                ?? line.constructPath(outerPoint: outerPoint, innerPoint: innerPoint, angles: fromAngles)
            let toPath = line.constructPath(outerPoint: outerPoint, innerPoint: innerPoint, angles: toAngles)

            let animation = CABasicAnimation(keyPath: "path")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.fromValue = fromPath
            animation.toValue = toPath
            line.path = toPath
            line.add(animation, forKey: "GraffeineAnimation.Data.RadialLine.Move")
        }
    }
}
