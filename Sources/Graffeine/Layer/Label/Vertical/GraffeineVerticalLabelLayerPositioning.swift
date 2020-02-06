import UIKit

public protocol GraffeineVerticalLabelLayerPositioning {
    func reposition(label: GraffeineVerticalLabelLayer.Label,
                    for index: Int,
                    in labels: [String?],
                    rowHeight: GraffeineLayer.DimensionalUnit,
                    rowMargin: CGFloat,
                    containerSize: CGSize)
}

extension GraffeineVerticalLabelLayer {

    public enum Positioner {
        case row
        case custom(GraffeineVerticalLabelLayerPositioning)

        public func get() -> GraffeineVerticalLabelLayerPositioning {
            switch self {
            case .row:
                return GraffeineVerticalLabelLayerRowPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
