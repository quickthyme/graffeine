import UIKit

extension GraffeinePieLayer {

    open class PieSlice: CAShapeLayer {

        public var clockwise: Bool = true
        public var rotation: UInt = 0
        public var radius: CGFloat = 0
        public var holeRadius: CGFloat = 0

        private var _angles: GraffeineAnglePair = .zero
        public var angles: GraffeineAnglePair { return _angles }

        open func reposition(for index: Int,
                             in percentages: [CGFloat],
                             centerPoint: CGPoint,
                             animator: GraffeinePieDataAnimating?) {
            let rotAngle = rotationAngle()
            let pctAngle = percentAngle(percentages[index])
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
            return percentAngle( CGFloat(rotation % 360) / 360 )
        }

        private func percentAngle(_ pct: CGFloat) -> CGFloat {
            let angle = (pct * CGFloat.pi * 2.0)
            return ((clockwise) ? angle : (0 - angle))
        }

        private func startingAngle(for index: Int, in percentages: [CGFloat]) -> CGFloat {
            let startingPercentage = percentages[0..<index].reduce(CGFloat(0)) { $0 + $1 }
            let angle = (startingPercentage * CGFloat.pi * 2.0)
            return ((clockwise) ? angle : (0 - angle))
        }

        open func constructPath(centerPoint: CGPoint, angles: GraffeineAnglePair) -> CGPath {

            let path = UIBezierPath(arcCenter: centerPoint,
                                    radius: radius,
                                    startAngle: angles.start,
                                    endAngle: angles.end,
                                    clockwise: clockwise)
            if holeRadius == 0 {
                path.addLine(to: centerPoint)
                path.close()
            } else {
                let holePoints = angles.points(center: centerPoint, radius: holeRadius)
                path.addLine(to: holePoints.end)
                path.addArc(withCenter: centerPoint, radius: holeRadius,
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
                self._angles = layer.angles
            }
        }
    }
}
