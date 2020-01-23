import UIKit

internal let OneDegreeInRadians = (CGFloat.pi / 180)

internal let DegreesToRadians: (CGFloat) -> (CGFloat) = {
    return $0 * OneDegreeInRadians
}

internal func resolveRadius(diameter: GraffeineLayer.DimensionalUnit, bounds: CGRect) -> CGFloat {
    let diameterBounds = min(bounds.size.width, bounds.size.height)
    let realDiameter = diameter.resolved(within: diameterBounds)
    return (realDiameter / 2)
}
