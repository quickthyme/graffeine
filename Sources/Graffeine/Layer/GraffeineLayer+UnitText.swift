import UIKit

extension GraffeineLayer {

    public struct UnitText {

        public var colors: [UIColor] = []
        public var fontSize: CGFloat = 10.0

        public init(colors:  [UIColor] = []) {
            self.colors = colors
        }

        public func indexedColor(_ idx: Int) -> CGColor? {
            guard (!colors.isEmpty) else { return nil }
            return colors[(idx % colors.count)].cgColor
        }

        public func apply(to target: CATextLayer, index: Int = 0) {
            target.foregroundColor = indexedColor(index)
            target.fontSize = self.fontSize
        }
    }
}
