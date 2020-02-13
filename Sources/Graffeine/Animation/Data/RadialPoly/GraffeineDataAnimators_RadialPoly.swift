import UIKit

public protocol GraffeineRadialPolyDataAnimating: GraffeineDataAnimating {
    func animate(poly: GraffeineRadialPolyLayer.Polygon, from: CGPath, to: CGPath)
}

extension GraffeineAnimation.Data {

    public struct RadialPoly {
        private init() {}
    }
}
