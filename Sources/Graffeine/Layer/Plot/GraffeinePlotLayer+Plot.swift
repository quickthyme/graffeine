import UIKit

extension GraffeinePlotLayer {

    open class Plot: CAShapeLayer {

        public var unitColumn: UnitColumn = UnitColumn()
        public var diameter: CGFloat = 0.0

        public func constructPath(at point: CGPoint) -> CGPath {
            return UIBezierPath(arcCenter: point,
                                radius: (diameter / 2),
                                startAngle: 0,
                                endAngle: FullCircleInRadians,
                                clockwise: true).cgPath
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.position = .zero
            self.opacity = 0
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Plot {
                self.unitColumn = layer.unitColumn
                self.diameter = layer.diameter
            }
        }
    }
}
