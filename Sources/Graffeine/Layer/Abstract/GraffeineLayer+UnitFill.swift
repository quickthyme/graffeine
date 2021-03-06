import UIKit

extension GraffeineLayer {

    public struct UnitFill {

        public var colors: [UIColor] = []
        public var opacity: CGFloat = 1.0

        public init(colors:  [UIColor] = []) {
            self.colors = colors
        }

        public func apply(to target: CAShapeLayer, index: Int = 0) {
            target.fillColor = Color.retrieve(at: index, cyclingThrough: colors)
            target.opacity = Float(opacity)
        }

        public func apply(to target: CATextLayer, index: Int = 0) {
            target.backgroundColor = Color.retrieve(at: index, cyclingThrough: colors)
            target.opacity = Float(opacity)
        }

        public func apply(to target: GraffeineLabel, index: Int = 0) {
            target.backgroundColor = Color.retrieve(at: index, cyclingThrough: colors)
            target.opacity = Float(opacity)
        }
    }
}
