import UIKit

public protocol GraffeineBarDataAnimating: GraffeineDataAnimating {
    func animate(bar: GraffeineBarLayer.Bar,
                 fromOrigin: CGPoint,
                 toOrigin: CGPoint,
                 fromSize: CGSize,
                 toSize: CGSize)
}

extension GraffeineDataAnimators {

    public struct Bar {
        private init() {}
    }
}
