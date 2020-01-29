import UIKit

extension GraffeineAnimation.Data.Label {

    public struct Slide: GraffeineLabelDataAnimating {

        public var duration: TimeInterval
        public var timing: CAMediaTimingFunctionName

        public init(duration: TimeInterval = 0.8,
                    timing: CAMediaTimingFunctionName = .linear) {
            self.duration = duration
            self.timing = timing
        }

        public func animate(label: GraffeineLabel,
                            toValue: String,
                            toFrame: CGRect,
                            toAlignment: GraffeineLabel.Alignment,
                            toPadding: GraffeineLabel.Padding) {

            let toBounds = CGRect(origin: .zero, size: toFrame.size)
            let fromFrame = label.presentation()?.frame ?? toFrame
            let fromBounds = label.presentation()?.bounds ?? toBounds
            let oldInternalPosition = CGPoint(x: label.getTextHPosition(fromBounds).x,
                                              y: label.getTextVPosition(fromBounds).y)
            let newInternalPosition = CGPoint(x: label.getTextHPosition(toBounds).x,
                                              y: label.getTextVPosition(toBounds).y)

            label.performWithoutAnimation {
                label.string = toValue
            }

            let animatePosition = CABasicAnimation(keyPath: "position")
            animatePosition.duration = duration
            animatePosition.fromValue = fromFrame.origin
            animatePosition.toValue = toFrame.origin

            let animateBounds = CABasicAnimation(keyPath: "bounds")
            animateBounds.duration = duration
            animateBounds.fromValue = fromBounds
            animateBounds.toValue = toBounds

            let animation = CAAnimationGroup()
            animation.timingFunction  = CAMediaTimingFunction(name: timing)
            animation.duration = duration
            animation.animations = [
                animatePosition,
                animateBounds
            ]

            let animateInternalPosition = CABasicAnimation(keyPath: "position")
            animateInternalPosition.timingFunction  = CAMediaTimingFunction(name: timing)
            animateInternalPosition.duration = duration
            animateInternalPosition.fromValue = oldInternalPosition
            animateInternalPosition.toValue = newInternalPosition

            label.position = toFrame.origin
            label.bounds = toBounds
            label.alignment = toAlignment
            label.padding = toPadding

            label.text.add(animateInternalPosition, forKey: "GraffeineAnimation.Data.Label.Slide")
            label.add(animation, forKey: "GraffeineAnimation.Data.Label.Slide")
        }
    }
}
