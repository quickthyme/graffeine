import UIKit

public protocol GraffeineRadialPolyLayerPositioning {
    func reposition(poly: GraffeineRadialPolyLayer.Polygon,
                    data: GraffeineData,
                    centerPoint: CGPoint,
                    animator: GraffeineRadialPolyDataAnimating?)
}

extension GraffeineRadialPolyLayer {

    public enum Positioner {
        case `default`
        case custom(GraffeineRadialPolyLayerPositioning)

        public func get() -> GraffeineRadialPolyLayerPositioning {
            switch self {
            case .default:
                return GraffeineRadialPolyLayerDefaultPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
