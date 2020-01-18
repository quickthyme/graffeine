import UIKit

extension GraffeineLayer {

    public enum DimensionalUnit: Equatable {

        case explicit(CGFloat)
        case percentage(CGFloat)
        case relative

        public func resolved(within boundary: CGFloat,
                             numberOfUnits: Int = 1,
                             unitMargin: CGFloat = 0.0) -> CGFloat {
            switch self {

            case let .explicit(val):
                return min(val, boundary)

            case let .percentage(val):
                return (0.0...1.0 ~= val) ? floor( (boundary * val) * 100 ) / 100 : boundary

            case .relative:
                let boundaryAdjustedForTrailingMargin = boundary + unitMargin
                return (numberOfUnits > 1)
                    ? (boundaryAdjustedForTrailingMargin / CGFloat(numberOfUnits)) - unitMargin
                    : boundary
            }
        }

        public func totalPossible(within boundary: CGFloat, unitMargin: CGFloat) -> Int {
            let unit = resolved(within: boundary) + unitMargin
            return Int( floor(boundary / unit) )
        }
    }
}
