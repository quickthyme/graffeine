import UIKit

public protocol GraffeineRadialLineLayerPositioning {
    func reposition(line: GraffeineRadialLineLayer.Line,
                    for index: Int,
                    in percentages: [CGFloat],
                    centerPoint: CGPoint,
                    animator: GraffeineRadialLineDataAnimating?)
}

extension GraffeineRadialLineLayer {

    public enum Positioner {
        case `default`
        case custom(GraffeineRadialLineLayerPositioning)

        public func get() -> GraffeineRadialLineLayerPositioning {
            switch self {
            case .default:
                return GraffeineRadialLineLayerDefaultPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
