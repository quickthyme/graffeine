import UIKit

internal let OneDegreeInRadians = (CGFloat.pi / 180)
internal let HalfDegreeInRadians = (OneDegreeInRadians / 2)
internal let FullCircleInRadians = (CGFloat.pi * 2.0)

internal func DegreesToRadians(_ deg: CGFloat, _ clockwise: Bool = true) -> CGFloat {
    let rad = deg * OneDegreeInRadians
    return (clockwise) ? rad : 0 - rad
}

internal func PercentageToRadians(_ pct: CGFloat, _ clockwise: Bool) -> CGFloat {
    let angle = (pct * FullCircleInRadians)
    return ((clockwise) ? angle : (0 - angle))
}

internal func resolveDiameter(diameter: GraffeineLayer.DimensionalUnit, bounds: CGRect) -> CGFloat {
    let diameterBounds = min(bounds.size.width, bounds.size.height)
    return diameter.resolved(within: diameterBounds)
}

internal func resolveRadius(diameter: GraffeineLayer.DimensionalUnit, bounds: CGRect) -> CGFloat {
    return resolveDiameter(diameter: diameter, bounds: bounds) / 2
}
