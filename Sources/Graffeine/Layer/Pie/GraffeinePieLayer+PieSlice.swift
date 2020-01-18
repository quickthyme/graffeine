import UIKit

extension GraffeinePieLayer {

    open class PieSlice: CAShapeLayer {

        public var clockwise: Bool = true
        public var rotation: UInt = 0
        public var radius: CGFloat = 0
        public var holeRadius: CGFloat = 0

        private var _angles: AnglePair = .zero
        public var angles: AnglePair { return _angles }

        private let oneDegreeRad = (CGFloat.pi / 180)

        open func reposition(for index: Int,
                             in percentages: [CGFloat],
                             centerPoint: CGPoint,
                             animated: Bool,
                             duration: TimeInterval,
                             timing: CAMediaTimingFunctionName) {
            let rotAngle = rotationAngle()
            let pctAngle = percentAngle(percentages[index])
            let startAngle = startingAngle(for: index, in: percentages) + rotAngle
            let newAngles = AnglePair(start: startAngle, end: startAngle + pctAngle)
            if (self.angles == .zero) {
                self._angles = AnglePair(start: newAngles.start, end: newAngles.start)
            }

            if (animated) {
                let animation = CAKeyframeAnimation(keyPath: "path")
                animation.timingFunction  = CAMediaTimingFunction(name: timing)
                animation.duration = duration
                animation.values = interpolatePaths(centerPoint: centerPoint, angles: newAngles)
                self.add(animation, forKey: "reposition")
            }

            self.path = pathForSlice(centerPoint: centerPoint, angles: newAngles)

            _angles = newAngles
        }

        private func degToRad(_ deg: CGFloat) -> CGFloat {
            return deg * oneDegreeRad
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

        private func pathForSlice(centerPoint: CGPoint, angles: AnglePair) -> CGPath {

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

        private func interpolatePaths(centerPoint: CGPoint, angles: AnglePair) -> [CGPath] {
            let origAngles = self.angles
            let startStep: CGFloat = (origAngles.start < angles.start) ? oneDegreeRad : -oneDegreeRad
            let endStep: CGFloat = (origAngles.end < angles.end) ? oneDegreeRad : -oneDegreeRad
            let eqAngles = equalizeAngles(
                [origAngles.start] + Array<CGFloat>(stride(from: origAngles.start, to: angles.start, by: startStep)) + [angles.start],
                [origAngles.end] + Array<CGFloat>(stride(from: origAngles.end, to: angles.end, by: endStep)) + [angles.end]
            )

            return zip(eqAngles.start, eqAngles.end).map {
                return pathForSlice(centerPoint: centerPoint,
                                    angles: AnglePair(start: $0.0, end: $0.1))
            }
        }

        func equalizeAngles(_ startAngles: [CGFloat], _ endAngles: [CGFloat]) -> (start: [CGFloat], end: [CGFloat]) {
            var startAngles = startAngles
            var endAngles = endAngles
            while startAngles.count < endAngles.count {
                startAngles.append(startAngles.last ?? 0)
            }
            while endAngles.count < startAngles.count {
                endAngles.append(endAngles.last ?? 0)
            }
            return (start: startAngles, end: endAngles)
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
