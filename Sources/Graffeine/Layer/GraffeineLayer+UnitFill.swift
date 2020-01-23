import UIKit

extension GraffeineLayer {

    public struct UnitFill {

        public var colors: [UIColor] = []

        public init(colors:  [UIColor] = []) {
            self.colors = colors
        }

        public func indexedColor(_ idx: Int) -> CGColor? {
            guard (!colors.isEmpty) else { return nil }
            return colors[(idx % colors.count)].cgColor
        }

        public func apply(to target: CAShapeLayer, index: Int? = nil) {
            let index = index ?? 0
            target.fillColor = indexedColor(index)
        }

        public func apply(to target: CATextLayer, index: Int? = nil) {
            let index = index ?? 0
            target.backgroundColor = indexedColor(index)
        }
    }
}
