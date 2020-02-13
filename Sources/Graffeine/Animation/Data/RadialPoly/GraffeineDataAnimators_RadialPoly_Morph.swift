import UIKit

extension GraffeineAnimation.Data.RadialPoly {

    public struct Morph: GraffeineRadialPolyDataAnimating {

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

        public func animate(poly: GraffeineRadialPolyLayer.Polygon, from: CGPath, to: CGPath) {
            let animation = CABasicAnimation(keyPath: "path")
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.beginTime = delay
            animation.duration = duration
            animation.fromValue = from
            animation.toValue = to
            poly.path = to
            poly.add(animation, forKey: "GraffeineAnimation.Data.RadialPoly.Morph")
        }
    }
}
