import UIKit

extension GraffeineLayer {

    public struct UnitLine {

        public var colors: [UIColor] = []
        public var thickness: CGFloat = 0.0
        public var dashPattern: [NSNumber]? = nil
        public var dashPhase: CGFloat = 0
        public var join: CAShapeLayerLineJoin = .bevel
        public var cap: CAShapeLayerLineCap = .butt

        public init(colors:  [UIColor] = [],
                    thickness: CGFloat = 0.0,
                    dashPattern: [NSNumber]? = nil,
                    dashPhase:  CGFloat = 0) {

            self.colors = colors
            self.thickness = thickness
            self.dashPattern = dashPattern
            self.dashPhase = dashPhase
        }

        public func indexedColor(_ idx: Int) -> CGColor? {
            guard (!colors.isEmpty) else { return nil }
            return colors[(idx % colors.count)].cgColor
        }

        public func apply(to target: CAShapeLayer, index: Int? = nil) {
            let index = index ?? 0
            target.strokeColor = indexedColor(index)
            target.lineWidth = self.thickness
            target.lineDashPattern = self.dashPattern
            target.lineDashPhase = self.dashPhase
            target.lineJoin = self.join
            target.lineCap = self.cap
        }

        public func apply(to target: CATextLayer, index: Int? = nil) {
            let index = index ?? 0
            target.borderColor = indexedColor(index)
        }
    }
}
