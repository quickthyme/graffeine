import UIKit

public protocol GraffeineBarLayerPositioning {
    func reposition(bar: GraffeineBarLayer.Bar,
                    for index: Int,
                    in data: GraffeineData,
                    containerSize: CGSize,
                    animator: GraffeineBarDataAnimating?)
}

extension GraffeineBarLayer {

    public enum Positioner {
        case `default`
        case custom(GraffeineBarLayerPositioning)

        public func get() -> GraffeineBarLayerPositioning {
            switch self {
            case .default:
                return GraffeineBarLayerDefaultPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
