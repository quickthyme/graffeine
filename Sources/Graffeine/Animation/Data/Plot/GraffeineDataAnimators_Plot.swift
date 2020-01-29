import UIKit

public protocol GraffeinePlotDataAnimating: GraffeineDataAnimating {
    var delayRatio: Double { get set }
    func animate(plot: GraffeinePlotLayer.Plot,
                 fromPath: CGPath,
                 toPath: CGPath)
}

extension GraffeineAnimation.Data {

    public struct Plot {
        private init() {}
    }
}
