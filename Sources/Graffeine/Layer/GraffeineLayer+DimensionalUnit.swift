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
                return (val < boundary) ? val : boundary

            case let .percentage(val):
                return (val >= 0 && val < 1.0) ? floor(boundary * val) : 1.0

            case .relative:
                let boundaryAdjustedForTrailingMargin = boundary + unitMargin
                return (numberOfUnits > 1)
                    ? ( boundaryAdjustedForTrailingMargin / CGFloat(numberOfUnits)) - unitMargin
                    : boundary
            }
        }

        public func totalPossible(within boundary: CGFloat, unitMargin: CGFloat) -> Int {
            let unit = resolved(within: boundary) + unitMargin
            return Int( floor(boundary / unit) )
        }
    }
}
