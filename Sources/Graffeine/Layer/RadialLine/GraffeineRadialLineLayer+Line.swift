import UIKit

extension GraffeineRadialLineLayer {

    open class Line: CAShapeLayer {

        public var clockwise: Bool = true
        public var rotation: Int = 0
        public var outerRadius: CGFloat = 0
        public var innerRadius: CGFloat = 0

        internal var _angles: GraffeineAnglePair = .zero
        public var angles: GraffeineAnglePair { return _angles }

        open func constructPath(outerPoint: CGPoint, innerPoint: CGPoint, angles: GraffeineAnglePair) -> CGPath {
            let path = UIBezierPath()
            path.move(to: innerPoint)
            path.addLine(to: outerPoint)
            return path.cgPath
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.backgroundColor = UIColor.clear.cgColor
            self.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.clockwise = layer.clockwise
                self.rotation = layer.rotation
                self.outerRadius = layer.outerRadius
                self.innerRadius = layer.innerRadius
                self._angles = layer.angles
            }
        }
    }
}
