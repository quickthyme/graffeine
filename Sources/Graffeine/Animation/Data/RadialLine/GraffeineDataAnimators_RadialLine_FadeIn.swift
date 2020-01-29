import UIKit

extension GraffeineAnimation.Data.RadialLine {

    public struct FadeIn: GraffeineRadialLineDataAnimating {

        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName
        public var delayRatio: Double

        public init(duration: TimeInterval = 0.8,
                    timing: CAMediaTimingFunctionName = .linear,
                    delayRatio: Double = 0.0) {
            self.duration = duration
            self.timing = timing
            self.delayRatio = delayRatio
        }

        public func animate(line: GraffeineRadialLineLayer.Line,
                            fromAngles: GraffeineAnglePair,
                            toAngles: GraffeineAnglePair,
                            outerPoint: CGPoint,
                            innerPoint: CGPoint) {

            let toPath = line.constructPath(outerPoint: outerPoint, innerPoint: innerPoint, angles: toAngles)

            line.performWithoutAnimation {
                line.opacity = 0.0
                line.path = toPath
            }

            let delayKeyTime = NSNumber(value: delayRatio)
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.values = [0.0, 0.0, 1.0]
            animation.keyTimes = [0.0, delayKeyTime, 1.0]
            line.opacity = 1.0
            line.add(animation, forKey: "GraffeineAnimation.Data.RadialLine.FadeIn")
        }
    }
}
