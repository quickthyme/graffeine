import UIKit

extension GraffeineLayer {

    public struct UnitSubdivision {
        public var offset: GraffeineLayer.DimensionalUnit? = nil
        public var width: GraffeineLayer.DimensionalUnit? = nil
        public init(offset: GraffeineLayer.DimensionalUnit? = nil,
                    width: GraffeineLayer.DimensionalUnit? = nil) {
            self.offset = offset
            self.width = width
        }

        public func resolved(in container: CGFloat) -> (offset: CGFloat, width: CGFloat) {
            return (
                offset: self.offset?.resolved(within: container) ?? 0.0,
                width: self.width?.resolved(within: container) ?? container
            )
        }
    }
}
