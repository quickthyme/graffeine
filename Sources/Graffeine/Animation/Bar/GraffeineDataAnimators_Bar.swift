import UIKit

public protocol GraffeineBarDataAnimating: GraffeineDataAnimating {
    func animate(bar: GraffeineBarLayer.Bar,
                 fromPosition: CGPoint,
                 toPosition: CGPoint,
                 fromSize: CGSize,
                 toSize: CGSize)
}

extension GraffeineDataAnimators {

    public struct Bar {
        private init() {}
    }
}
