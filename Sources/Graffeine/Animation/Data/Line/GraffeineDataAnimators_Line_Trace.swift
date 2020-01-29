import UIKit

extension GraffeineAnimation.Data.Line {

    public struct Trace: GraffeineLineDataAnimating {

        public var delay: TimeInterval
        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName

        public let animationKey: String = "GraffeineAnimation.Data.Line.Trace"

        internal var animationDelegate: AnimationDelegate = AnimationDelegate()

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
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            animation.delegate = animationDelegate
            animationDelegate.lineBeingAnimated = line
            animationDelegate.animationKey = animationKey
            line.add(animation, forKey: animationKey)
        }

        internal class AnimationDelegate: NSObject, CAAnimationDelegate {
            var lineBeingAnimated: GraffeineLineLayer.Line? = nil
            var animationKey: String = ""
            func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
                lineBeingAnimated?.strokeEnd = 1.0
                lineBeingAnimated?.removeAnimation(forKey: animationKey)
            }
        }
    }
}
