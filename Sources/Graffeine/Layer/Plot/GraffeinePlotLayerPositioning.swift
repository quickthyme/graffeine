import UIKit

public protocol GraffeinePlotLayerPositioning {
    func reposition(plot: GraffeinePlotLayer.Plot,
                    for index: Int,
                    in data: GraffeineData,
                    containerSize: CGSize,
                    animator: GraffeinePlotDataAnimating?)
}

extension GraffeinePlotLayer {

    public enum Positioner {
        case column
        case xy
        case custom(GraffeinePlotLayerPositioning)

        public func get() -> GraffeinePlotLayerPositioning {
            switch self {
            case .column:
                return GraffeinePlotLayerColumnPositioner()

            case .xy:
                return GraffeinePlotLayerXYPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
