import UIKit

extension GraffeineDataAnimators.Line {

    public struct Morph: GraffeineLineDataAnimating {

        public var delay: TimeInterval
        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName

        public init(delay: TimeInterval = 0.0,
                    duration: TimeInterval = 0.8,
                    timing: CAMediaTimingFunctionName = .linear) {
            self.delay = delay
            self.duration = duration
            self.timing = timing
        }

        public func animate(line: GraffeineLineLayer.Line, from: CGPath, to: CGPath) {
            let animation = CABasicAnimation(keyPath: "path")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.beginTime = delay
            animation.duration = duration
            animation.fromValue = from
            animation.toValue = to
            line.path = to
            line.add(animation, forKey: "GraffeineDataAnimators.Line.Morph")
        }
    }
}
