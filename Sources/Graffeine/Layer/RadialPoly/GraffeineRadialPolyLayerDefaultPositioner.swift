import UIKit

public struct GraffeineRadialPolyLayerDefaultPositioner: GraffeineRadialPolyLayerPositioning {

    typealias DimensionalUnit = GraffeineLayer.DimensionalUnit

    public func reposition(poly: GraffeineRadialPolyLayer.Polygon,
                           data: GraffeineData,
                           centerPoint: CGPoint,
                           animator: GraffeineRadialPolyDataAnimating?) {
        let rotAngle = rotationAngle(poly.rotation, true)
        let numberOfValues = data.values.hi.count
        let eachPct = CGFloat(1) / CGFloat(numberOfValues)
        let eachAngle = PercentageToRadians(eachPct, true)
        let angles: [GraffeineAnglePair] = (0..<numberOfValues).reduce([GraffeineAnglePair]()) { result, _ in
            let lastAngle = result.last ?? GraffeineAnglePair(start: rotAngle, end: rotAngle)
            let start = lastAngle.end
            let end   = lastAngle.end + eachAngle
            return result + [GraffeineAnglePair(start: start, end: end)]
        }

        let valueMax = data.valueMaxOrHighestHi
        let maxRadius = poly.maxRadius

        let radii: [CGFloat] = data.values.hi.map {
            let dim: DimensionalUnit = .percentage(CGFloat($0 ?? 0) / CGFloat(valueMax))
            return dim.resolved(within: maxRadius)
        }

        let toPath = poly.constructPath(radii: radii,
                                        angles: angles,
                                        centerPoint: centerPoint)
        let fromPath = poly.presentation()?.path ?? toPath

        if let animator = animator {
            animator.animate(poly: poly,
                             from: fromPath,
                             to: toPath)
        } else {
            poly.performWithoutAnimation {
                poly.path = toPath
            }
        }
    }

    private func rotationAngle(_ rotation: Int, _ clockwise: Bool) -> CGFloat {
        return PercentageToRadians( CGFloat(rotation % 360) / 360 , clockwise)
    }
}
