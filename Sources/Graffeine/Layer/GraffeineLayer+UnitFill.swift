import UIKit

extension GraffeineLayer {

    public struct UnitFill {

        public var colors: [UIColor] = []

        public init(colors:  [UIColor] = []) {
            self.colors = colors
        }

        public func apply(to target: CAShapeLayer, index: Int = 0) {
            target.fillColor = ColorIndex.retrieve(at: index, cyclingThrough: colors)
        }

        public func apply(to target: CATextLayer, index: Int = 0) {
            target.backgroundColor = ColorIndex.retrieve(at: index, cyclingThrough: colors)
        }

        public func apply(to target: GraffeineLabel, index: Int = 0) {
            target.backgroundColor = ColorIndex.retrieve(at: index, cyclingThrough: colors)
        }
    }
}
