import UIKit

public protocol GraffeineLabelDataAnimating: GraffeineDataAnimating {
    func animate(label: GraffeineLabel,
                 toValue: String,
                 toFrame: CGRect,
                 toAlignment: GraffeineLabel.Alignment,
                 toPadding: GraffeineLabel.Padding)
}

extension GraffeineAnimation.Data {

    public struct Label {
        private init() {}
    }
}
