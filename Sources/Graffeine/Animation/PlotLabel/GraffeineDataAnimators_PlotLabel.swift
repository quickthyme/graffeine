import UIKit

public protocol GraffeinePlotLabelDataAnimating: GraffeineDataAnimating {
    func animate(label: GraffeinePlotLabelLayer.Label,
                 toValue: String,
                 toPosition: CGPoint)
}

extension GraffeineDataAnimators {

    public struct PlotLabel {
        private init() {}
    }
}
