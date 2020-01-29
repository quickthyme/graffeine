import UIKit

extension GraffeineAnimation.Perpetual {

    public static func MarchingAnts(dashPhase: Int,
                                    clockwise: Bool = true,
                                    duration: TimeInterval = 0.3) -> CAAnimation {

        let toValue = (clockwise) ? 0 - dashPhase : dashPhase
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = NSNumber(value: 0)
        animation.toValue = NSNumber(value: toValue)
        animation.duration = duration
        animation.repeatCount = .infinity
        return animation
    }
}
