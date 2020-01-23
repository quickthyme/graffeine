import UIKit

extension GraffeinePieLayer {

    open class PieSlice: CAShapeLayer {

        public var clockwise: Bool = true
        public var rotation: UInt = 0
        public var radius: CGFloat = 0
        public var holeRadius: CGFloat = 0
        public var centerOffsetRadius: CGFloat = 0

        private var _angles: GraffeineAnglePair = .zero
        public var angles: GraffeineAnglePair { return _angles }

        open func reposition(for index: Int,
                             in percentages: [CGFloat],
                             centerPoint: CGPoint,
                             animator: GraffeinePieDataAnimating?) {
            let rotAngle = rotationAngle()
            let pctAngle = PercentageToRadians(percentages[index], clockwise)
            let startAngle = startingAngle(for: index, in: percentages) + rotAngle
            let newAngles = GraffeineAnglePair(start: startAngle, end: startAngle + pctAngle)
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
            let offsetRadius = radius - centerOffsetRadius

            let path = UIBezierPath(arcCenter: offsetCenter,
                                    radius: offsetRadius,
                                    startAngle: angles.start,
                                    endAngle: angles.end,
                                    clockwise: clockwise)
            if holeRadius == 0 {
                path.addLine(to: offsetCenter)
                path.close()
            } else {
                let offsetHoleRadius = holeRadius - centerOffsetRadius
                let holePoints = angles.points(center: offsetCenter, radius: offsetHoleRadius)
                path.addLine(to: holePoints.end)
                path.addArc(withCenter: offsetCenter,
                            radius: offsetHoleRadius,
                            startAngle: angles.end,
                            endAngle: angles.start,
                            clockwise: !clockwise)
                path.close()
            }

            return path.cgPath
        }


        override public init() {
            super.init()
            self.masksToBounds = true
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
                self.radius = layer.radius
                self.holeRadius = layer.holeRadius
                self.centerOffsetRadius = layer.centerOffsetRadius
                self._angles = layer.angles
            }
        }
    }
}
