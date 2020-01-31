import UIKit

public protocol GraffeinePlotLabelLayerPositioning {
    func reposition(label: GraffeinePlotLabelLayer.Label,
                    for index: Int,
                    in data: GraffeineData,
                    containerSize: CGSize,
                    animator: GraffeinePlotLabelDataAnimating?)
}

extension GraffeinePlotLabelLayer {

    public enum Positioner {
        case column
        case xy
        case custom(GraffeinePlotLabelLayerPositioning)

        public func get() -> GraffeinePlotLabelLayerPositioning {
            switch self {
            case .column:
                return GraffeinePlotLabelLayerColumnPositioner()

            case .xy:
                return GraffeinePlotLabelLayerXYPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
