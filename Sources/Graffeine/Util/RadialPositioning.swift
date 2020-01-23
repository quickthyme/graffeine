import UIKit

internal let OneDegreeInRadians = (CGFloat.pi / 180)

internal let DegreesToRadians: (CGFloat) -> (CGFloat) = {
    return $0 * OneDegreeInRadians
}

internal func resolveDiameter(diameter: GraffeineLayer.DimensionalUnit, bounds: CGRect) -> CGFloat {
    let diameterBounds = min(bounds.size.width, bounds.size.height)
    return diameter.resolved(within: diameterBounds)
}

internal func resolveRadius(diameter: GraffeineLayer.DimensionalUnit, bounds: CGRect) -> CGFloat {
    return resolveDiameter(diameter: diameter, bounds: bounds) / 2
}
