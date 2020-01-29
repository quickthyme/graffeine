import UIKit

extension GraffeineAnimation.Data.PieLabel {

    public struct FadeIn: GraffeinePieLabelDataAnimating {

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

        public func animate(label: GraffeinePieLabelLayer.Label,
                            fromAngles: GraffeineAnglePair,
                            toAngles: GraffeineAnglePair,
                            labelPoint: CGPoint,
                            centerPoint: CGPoint) {

            label.performWithoutAnimation {
                label.opacity = 0.0
                label.position = labelPoint
            }

            let delayKeyTime = NSNumber(value: delayRatio)
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.values = [0.0, 0.0, 1.0]
            animation.keyTimes = [0.0, delayKeyTime, 1.0]
            label.opacity = 1.0
            label.add(animation, forKey: "GraffeineAnimation.Data.PieLabel.FadeIn")
        }
    }
}
