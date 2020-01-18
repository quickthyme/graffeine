import UIKit

extension GraffeinePieLayer {

    open class PieSlice: CAShapeLayer {

        open var clockwise: Bool = true
        open var rotation: UInt = 0

        private var _startAngle: CGFloat = 0
        public var startAngle: CGFloat { return _startAngle }

        private var _endAngle: CGFloat = 0
        public var endAngle: CGFloat { return _endAngle }

        private var _radius: CGFloat = 0
        public var radius: CGFloat { return _radius }

        private let oneDegreeRad = (CGFloat.pi / 180)

        open func reposition(for index: Int,
                             in percentages: [CGFloat],
                             radius: CGFloat,
                             centerPoint: CGPoint,
                             animated: Bool,
                             duration: TimeInterval,
                             timing: CAMediaTimingFunctionName) {
            let rotAngle = rotationAngle()
            let pctAngle = percentAngle(percentages[index])
            let startAngle = startingAngle(for: index, in: percentages) + rotAngle
            let endAngle = startAngle + pctAngle

            if (animated /*&& (_startAngle != _endAngle)*/) {
                let animation = CAKeyframeAnimation(keyPath: "path")
                animation.timingFunction  = CAMediaTimingFunction(name: timing)
                animation.duration = duration
                animation.values = interpolatePaths(centerPoint: centerPoint,
                                                    radius: radius,
                                                    startAngle: startAngle,
                                                    endAngle: endAngle)
                self.add(animation, forKey: "reposition")
            }
            self.path = pathForSlice(centerPoint: centerPoint,
                                     radius: radius,
                                     startAngle: startAngle,
                                     endAngle: endAngle)
            _startAngle = startAngle
            _endAngle = endAngle
            _radius = radius
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

        private func pathForSlice(centerPoint: CGPoint,
                                  radius: CGFloat,
                                  startAngle: CGFloat,
                                  endAngle: CGFloat) -> CGPath {
            let path = UIBezierPath(arcCenter: centerPoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: clockwise)
            path.addLine(to: centerPoint)
            path.close()
            return path.cgPath
        }

        private func interpolatePaths(centerPoint: CGPoint,
                                      radius: CGFloat,
                                      startAngle: CGFloat,
                                      endAngle: CGFloat) -> [CGPath] {
            let origStartAngle = self.startAngle
            let origEndAngle = self.endAngle
            let startStep: CGFloat = (origStartAngle < startAngle) ? oneDegreeRad : -oneDegreeRad
            let endStep: CGFloat = (origEndAngle < endAngle) ? oneDegreeRad : -oneDegreeRad
            let angles = equalizeAngles(
                [origStartAngle] + Array<CGFloat>(stride(from: origStartAngle, to: startAngle, by: startStep)) + [startAngle],
                [origEndAngle] + Array<CGFloat>(stride(from: origEndAngle, to: endAngle, by: endStep)) + [endAngle]
            )

            return zip(angles.start, angles.end).map {
                return pathForSlice(centerPoint: centerPoint,
                                    radius: radius,
                                    startAngle: $0.0,
                                    endAngle: $0.1)
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
                self._startAngle = layer.startAngle
                self._endAngle = layer.endAngle
            }
        }
    }
}
