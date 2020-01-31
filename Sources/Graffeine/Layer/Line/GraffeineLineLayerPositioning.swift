import UIKit

public protocol GraffeineLineLayerPositioning {
    func reposition(line: GraffeineLineLayer.Line,
                    data: GraffeineData,
                    containerSize: CGSize,
                    smoothing: GraffeineLineLayer.Smoothing,
                    animator: GraffeineLineDataAnimating?)
}

extension GraffeineLineLayer {

    public enum Positioner {
        case column
        case custom(GraffeineLineLayerPositioning)

        public func get() -> GraffeineLineLayerPositioning {
            switch self {
            case .column:
                return GraffeineLineLayerColumnPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
