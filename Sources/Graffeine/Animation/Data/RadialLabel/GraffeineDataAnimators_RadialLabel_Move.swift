import UIKit

extension GraffeineAnimation.Data.RadialLabel {

    public struct Move: GraffeineRadialLabelDataAnimating {

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

        public func animate(label: GraffeineRadialLabelLayer.Label,
                            fromAngles: GraffeineAnglePair,
                            toAngles: GraffeineAnglePair,
                            labelPoint: CGPoint,
                            centerPoint: CGPoint) {

            let currentPoint = label.presentation()?.position ?? centerPoint

            let delayKeyTime = NSNumber(value: delayRatio)
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.values = [currentPoint, currentPoint, labelPoint]
            animation.keyTimes = [0.0, delayKeyTime, 1.0]
            label.position = labelPoint
            label.add(animation, forKey: "GraffeineAnimation.Data.RadialLabel.Move")
        }
    }
}
