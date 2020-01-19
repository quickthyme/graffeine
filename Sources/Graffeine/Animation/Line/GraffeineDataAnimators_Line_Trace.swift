import UIKit

extension GraffeineDataAnimators.Line {

    public struct Trace: GraffeineLineDataAnimating {

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
            line.performWithoutAnimation {
                line.strokeEnd = 0
                line.path = to
            }

            let animation = CABasicAnimation(keyPath: "strokeEnd")
            if (delay > 0) {
                animation.beginTime = CACurrentMediaTime() + delay
            }
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.fromValue = 0.0
            animation.toValue = 1.0

            if (delay > 0) {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    line.strokeEnd = 1.0
                }
            } else {
                line.strokeEnd = 1.0
            }
            line.add(animation, forKey: "GraffeineDataAnimators.Line.Trace")
        }
    }
}
