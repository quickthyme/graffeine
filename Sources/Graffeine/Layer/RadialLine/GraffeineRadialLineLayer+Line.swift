import UIKit

extension GraffeineRadialLineLayer {

    open class Line: CAShapeLayer {

        public var clockwise: Bool = true
        public var rotation: UInt = 0
        public var outerRadius: CGFloat = 0
        public var innerRadius: CGFloat = 0

        private var _angles: GraffeineAnglePair = .zero
        public var angles: GraffeineAnglePair { return _angles }

        open func reposition(for index: Int,
                             in percentages: [CGFloat],
                             centerPoint: CGPoint,
                             animator: GraffeineRadialLineDataAnimating?) {
            let rotAngle = rotationAngle()
            let pctAngle = PercentageToRadians(percentages[index], clockwise)
            let startAngle = startingAngle(for: index, in: percentages) + rotAngle
            let newAngles = GraffeineAnglePair(start: startAngle, end: startAngle + pctAngle)
            if (self.angles == .zero) {
                self._angles = GraffeineAnglePair(start: newAngles.start, end: newAngles.start)
            }

            let middleAngle = newAngles.middle

            let outerPoint = GraffeineAnglePair.point(for: middleAngle,
                                                      center: centerPoint,
                                                      radius: outerRadius)

            let innerPoint = GraffeineAnglePair.point(for: middleAngle,
                                                      center: centerPoint,
                                                      radius: innerRadius)

            if let animator = animator {
                animator.animate(line: self,
                                 fromAngles: self.angles,
                                 toAngles: newAngles,
                                 outerPoint: outerPoint,
                                 innerPoint: innerPoint)
            } else {
                performWithoutAnimation {
                    self.path = constructPath(outerPoint: outerPoint,
                                              innerPoint: innerPoint,
                                              angles: newAngles)
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
