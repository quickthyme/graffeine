import UIKit

public protocol GraffeinePlotLabelDataAnimating: GraffeineDataAnimating {
    func animate(label: GraffeinePlotLabelLayer.Label,
                 toValue: String,
                 toPosition: CGPoint)
}

extension GraffeineAnimation.Data {

    public struct PlotLabel {
        private init() {}
    }
}
