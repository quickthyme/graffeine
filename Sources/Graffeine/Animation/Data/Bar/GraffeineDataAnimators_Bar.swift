import UIKit

public protocol GraffeineBarDataAnimating: GraffeineDataAnimating {
    func animate(bar: GraffeineBarLayer.Bar,
                 fromOrigin: CGPoint,
                 toOrigin: CGPoint,
                 fromSize: CGSize,
                 toSize: CGSize)
}

extension GraffeineAnimation.Data {

    public struct Bar {
        private init() {}
    }
}
