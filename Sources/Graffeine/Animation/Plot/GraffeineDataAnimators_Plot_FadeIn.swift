import UIKit

extension GraffeineDataAnimators.Plot {

    public struct FadeIn: GraffeinePlotDataAnimating {

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

        public func animate(plot: GraffeinePlotLayer.Plot,
                            fromPath: CGPath,
                            toPath: CGPath) {

            plot.performWithoutAnimation {
                plot.opacity = 0.0
                plot.path = toPath
            }

            let delayKeyTime = NSNumber(value: delayRatio)
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.values = [0.0, 0.0, 1.0]
            animation.keyTimes = [0.0, delayKeyTime, 1.0]
            plot.opacity = 1.0
            plot.add(animation, forKey: "GraffeineDataAnimators.Plot.FadeIn")
        }
    }
}
