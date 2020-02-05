import UIKit

extension GraffeineRadialSegmentLayer {

    open class Segment: CAShapeLayer {

        public var clockwise: Bool = true
        public var rotation: UInt = 0
        public var outerRadius: CGFloat = 0
        public var innerRadius: CGFloat = 0
        public var centerOffsetRadius: CGFloat = 0

        internal var _angles: GraffeineAnglePair = .zero
        public var angles: GraffeineAnglePair { return _angles }

        public func constructPath(centerPoint: CGPoint,
                                  angles: GraffeineAnglePair) -> CGPath {

            let offsetCenter = GraffeineAnglePair.point(for: angles.middle,
                                                        center: centerPoint,
                                                        radius: centerOffsetRadius)
            let offsetRadius = outerRadius - centerOffsetRadius

            let path = UIBezierPath(arcCenter: offsetCenter,
                                    radius: offsetRadius,
                                    startAngle: angles.start,
                                    endAngle: angles.end,
                                    clockwise: true)
            if innerRadius == 0 {
                path.addLine(to: offsetCenter)
                path.close()
            } else {
                let offsetInnerRadius = innerRadius - centerOffsetRadius
                let innerPoints = angles.points(center: offsetCenter, radius: offsetInnerRadius)
                path.addLine(to: innerPoints.end)
                path.addArc(withCenter: offsetCenter,
                            radius: offsetInnerRadius,
                            startAngle: angles.end,
                            endAngle: angles.start,
                            clockwise: false)
                path.close()
            }

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
                self.centerOffsetRadius = layer.centerOffsetRadius
                self._angles = layer.angles
            }
        }
    }
}
