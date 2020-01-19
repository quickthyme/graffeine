import UIKit

public protocol GraffeinePlotDataAnimating: GraffeineDataAnimating {
    var delayRatio: Double { get set }
    func animate(plot: GraffeinePlotLayer.Plot,
                 fromPosition: CGPoint,
                 toPosition: CGPoint,
                 fromShape: CGPath,
                 toShape: CGPath)
}

extension GraffeineDataAnimators {

    public struct Plot {
        private init() {}
    }
}
