import UIKit

public protocol GraffeineRadialSegmentLayerPositioning {
    func reposition(segment: GraffeineRadialSegmentLayer.Segment,
                    for index: Int,
                    in percentages: [CGFloat],
                    centerPoint: CGPoint,
                    animator: GraffeineRadialSegmentDataAnimating?)
}

extension GraffeineRadialSegmentLayer {

    public enum Positioner {
        case `default`
        case custom(GraffeineRadialSegmentLayerPositioning)

        public func get() -> GraffeineRadialSegmentLayerPositioning {
            switch self {
            case .default:
                return GraffeineRadialSegmentLayerDefaultPositioner()

            case let .custom(positioner):
                return positioner
            }
        }
    }
}
