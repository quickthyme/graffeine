import UIKit

extension GraffeineLayer {

    public struct UnitSubdivision {
        public let index: Int
        public let width: GraffeineLayer.DimensionalUnit
        public init(index: Int, width: GraffeineLayer.DimensionalUnit) {
            self.index = index
            self.width = width
        }
    }
}
