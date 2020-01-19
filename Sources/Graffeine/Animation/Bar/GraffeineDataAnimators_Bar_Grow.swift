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
                            fromPosition: CGPoint,
                            toPosition: CGPoint,
                            fromSize: CGSize,
                            toSize: CGSize) {

            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: timing))
            bar.position = toPosition
            bar.frame.size = toSize
            CATransaction.commit()
        }
    }
}
