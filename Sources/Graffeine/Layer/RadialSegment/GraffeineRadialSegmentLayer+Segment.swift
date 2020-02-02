import UIKit

extension GraffeineRadialSegmentLayer {

    open class Segment: CAShapeLayer {

        public var clockwise: Bool = true
        public var rotation: UInt = 0
        public var outerRadius: CGFloat = 0
        public var innerRadius: CGFloat = 0
        public var centerOffsetRadius: CGFloat = 0

        private var _angles: GraffeineAnglePair = .zero
        public var angles: GraffeineAnglePair { return _angles }

        open func reposition(for index: Int,
                             in percentages: [CGFloat],
                             centerPoint: CGPoint,
                             animator: GraffeineRadialSegmentDataAnimating?) {
            let rotAngle = rotationAngle()
            let pctAngle = PercentageToRadians(percentages[index], clockwise)
            let startAngle = (clockwise)
                ? (0 + startingAngle(for: index, in: percentages)) + rotAngle
                : (0 - startingAngle(for: index, in: percentages)) + rotAngle
            let endAngle = startAngle + pctAngle
            let newAngles = (clockwise)
                ? GraffeineAnglePair(start: startAngle, end: endAngle)
                : GraffeineAnglePair(start: endAngle, end: startAngle)

            if (self.angles == .zero) {
                self._angles = GraffeineAnglePair(start: newAngles.start, end: newAngles.start)
            }

            if let animator = animator {
                animator.animate(pieSlice: self,
                                 fromAngles: self.angles,
                                 toAngles: newAngles,
                                 centerPoint: centerPoint)
            } else {
                performWithoutAnimation {
                    self.path = constructPath(centerPoint: centerPoint, angles: newAngles)
                }
            }
            _angles = newAngles
        }

        private func rotationAngle() -> CGFloat {
            return PercentageToRadians( CGFloat(rotation % 360) / 360 , clockwise)
        }

        private func startingAngle(for index: Int, in percentages: [CGFloat]) -> CGFloat {
            let startingPercentage = percentages[0..<index].reduce(CGFloat(0)) { $0 + $1 }
            let angle = PercentageToRadians(startingPercentage, clockwise)
            return ((clockwise) ? angle : (0 - angle))
        }

        open func constructPath(centerPoint: CGPoint, angles: GraffeineAnglePair) -> CGPath {

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
