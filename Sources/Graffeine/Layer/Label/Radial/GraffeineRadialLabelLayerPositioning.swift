import UIKit

public protocol GraffeineRadialLabelLayerPositioning {
    func reposition(label: GraffeineRadialLabelLayer.Label,
                    for index: Int,
                    in percentages: [CGFloat],
                    centerPoint: CGPoint,
                    animator: GraffeineRadialLabelDataAnimating?)
}

extension GraffeineRadialLabelLayer {

    public enum Positioner {
        case `default`
        case custom(GraffeineRadialLabelLayerPositioning)

        public func get() -> GraffeineRadialLabelLayerPositioning {
            switch self {
            case .default:
                return GraffeineRadialLabelLayerDefaultPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
