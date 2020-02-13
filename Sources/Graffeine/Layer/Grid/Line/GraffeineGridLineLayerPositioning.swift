import UIKit

public protocol GraffeineGridLineLayerPositioning {
    func reposition(line: GraffeineGridLineLayer.GridLine,
                    for index: Int,
                    in data: GraffeineData,
                    containerSize: CGSize)
}

extension GraffeineGridLineLayer {

    public enum Positioner {
        case `default`
        case custom(GraffeineGridLineLayerPositioning)

        public func get() -> GraffeineGridLineLayerPositioning {
            switch self {
            case .default:
                return GraffeineGridLineLayerDefaultPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
