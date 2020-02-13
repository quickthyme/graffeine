import UIKit

extension GraffeineRadialGridLayer {

    open class GridLine: CAShapeLayer {

        public var maxRadius: CGFloat = 0

        public func constructPath(radius: CGFloat,
                                  centerPoint: CGPoint) -> UIBezierPath{

            let path = UIBezierPath(arcCenter: centerPoint,
                                    radius: radius,
                                    startAngle: 0,
                                    endAngle: FullCircleInRadians,
                                    clockwise: true)
            return path
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.backgroundColor = UIColor.clear.cgColor
            self.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.fillColor = nil
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.maxRadius = layer.maxRadius
            }
        }
    }
}
