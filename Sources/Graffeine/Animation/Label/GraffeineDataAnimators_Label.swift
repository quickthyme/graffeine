import UIKit

public protocol GraffeineLabelDataAnimating: GraffeineDataAnimating {
    func animate(label: GraffeineLabel,
                 toValue: String,
                 toFrame: CGRect,
                 toAlignment: GraffeineLabel.Alignment,
                 toPadding: GraffeineLabel.Padding)
}

extension GraffeineDataAnimators {

    public struct Label {
        private init() {}
    }
}
