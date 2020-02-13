import UIKit

public protocol GraffeineRadialGridLayerPositioning {
    func reposition(line: GraffeineRadialGridLayer.GridLine,
                    for index: Int,
                    in data: GraffeineData,
                    containerSize: CGSize)
}

extension GraffeineRadialGridLayer {

    public enum Positioner {
        case `default`
        case custom(GraffeineRadialGridLayerPositioning)

        public func get() -> GraffeineRadialGridLayerPositioning {
            switch self {
            case .default:
                return GraffeineRadialGridLayerDefaultPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
