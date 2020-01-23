import UIKit

extension GraffeineLayer {

    public struct UnitLine {

        public var colors: [UIColor]
        public var thickness: CGFloat
        public var dashPattern: [NSNumber]?
        public var dashPhase: CGFloat
        public var join: CAShapeLayerLineJoin
        public var cap: CAShapeLayerLineCap

        public init(colors:  [UIColor] = [],
                    thickness: CGFloat = 0.0,
                    dashPattern: [NSNumber]? = nil,
                    dashPhase:  CGFloat = 0,
                    join: CAShapeLayerLineJoin = .bevel,
                    cap: CAShapeLayerLineCap = .butt) {

            self.colors = colors
            self.thickness = thickness
            self.dashPattern = dashPattern
            self.dashPhase = dashPhase
            self.join = join
            self.cap = cap
        }

        public func apply(to target: CAShapeLayer, index: Int = 0) {
            target.strokeColor = ColorIndex.retrieve(at: index, cyclingThrough: colors)
            target.lineWidth = self.thickness
            target.lineDashPattern = self.dashPattern
            target.lineDashPhase = self.dashPhase
            target.lineJoin = self.join
            target.lineCap = self.cap
        }

        public func apply(to target: CATextLayer, index: Int = 0) {
            target.borderColor = ColorIndex.retrieve(at: index, cyclingThrough: colors)
            target.borderWidth = self.thickness
        }
    }
}
