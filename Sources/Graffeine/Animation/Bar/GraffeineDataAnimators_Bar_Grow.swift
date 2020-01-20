import UIKit

extension GraffeineDataAnimators.Bar {

    public struct Grow: GraffeineBarDataAnimating {

        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName

        public init(duration: TimeInterval, timing: CAMediaTimingFunctionName) {
            self.duration = duration
            self.timing = timing
        }

        public func animate(bar: GraffeineBarLayer.Bar,
                            fromOrigin: CGPoint,
                            toOrigin: CGPoint,
                            fromSize: CGSize,
                            toSize: CGSize) {

            let fromPath = bar.presentation()?.path
                ?? bar.constructPath(origin: fromOrigin, size: fromSize)
            let toPath = bar.constructPath(origin: toOrigin, size: toSize)

            let animation = CABasicAnimation(keyPath: "path")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.fromValue = fromPath
            animation.toValue = toPath
            bar.path = toPath
            bar.add(animation, forKey: "GraffeineDataAnimators.Bar.Grow")
        }
    }
}
