import UIKit

public protocol GraffeineHorizontalLabelLayerPositioning {
    func reposition(label: GraffeineHorizontalLabelLayer.Label,
                    for index: Int,
                    in labels: [String?],
                    containerSize: CGSize)
}

extension GraffeineHorizontalLabelLayer {

    public enum Positioner {
        case column
        case custom(GraffeineHorizontalLabelLayerPositioning)

        public func get() -> GraffeineHorizontalLabelLayerPositioning {
            switch self {
            case .column:
                return GraffeineHorizontalLabelLayerColumnPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
