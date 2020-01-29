import UIKit

extension GraffeineAnimation.Data.PlotLabel {

    public struct FadeIn: GraffeinePlotLabelDataAnimating {

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

        public func animate(label: GraffeinePlotLabelLayer.Label,
                            toValue: String,
                            toPosition: CGPoint) {

            label.performWithoutAnimation {
                label.opacity = 0.0
                label.string = toValue
                label.frame.size = label.preferredFrameSize()
                label.position = toPosition
            }

            let delayKeyTime = NSNumber(value: delayRatio)
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.values = [0.0, 0.0, 1.0]
            animation.keyTimes = [0.0, delayKeyTime, 1.0]
            label.opacity = 1.0
            label.add(animation, forKey: "GraffeineAnimation.Data.PlotLabel.FadeIn")
        }
    }
}
