import UIKit

extension GraffeineLayer {

    public struct UnitText {

        public var colors: [UIColor] = []
        public var fontSize: CGFloat = 10.0

        public init(colors:  [UIColor] = []) {
            self.colors = colors
        }

        public func apply(to target: CATextLayer, index: Int = 0) {
            target.foregroundColor = Color.retrieve(at: index, cyclingThrough: colors)
            target.fontSize = self.fontSize
        }

        public func apply(to target: GraffeineLabel, index: Int = 0) {
            target.foregroundColor = Color.retrieve(at: index, cyclingThrough: colors)
            target.fontSize = self.fontSize
        }
    }
}
