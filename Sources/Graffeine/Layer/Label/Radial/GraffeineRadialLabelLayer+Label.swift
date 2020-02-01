import UIKit

extension GraffeineRadialLabelLayer {

    open class Label: GraffeineLabel {

        public var clockwise: Bool = true
        public var rotation: UInt = 0
        public var radius: CGFloat = 0
        public var distributedAlignment = DistributedLabelAlignment(horizontal: .center, vertical: .center)

        private var _angles: GraffeineAnglePair = .zero
        public var angles: GraffeineAnglePair { return _angles }

        open func reposition(for index: Int,
                             in percentages: [CGFloat],
                             centerPoint: CGPoint,
                             animator: GraffeineRadialLabelDataAnimating?) {
            let rotAngle = rotationAngle()
            let pctAngle = percentAngle(percentages[index])
            let startAngle = startingAngle(for: index, in: percentages) + rotAngle
            let newAngles = GraffeineAnglePair(start: startAngle, end: startAngle + pctAngle)
            if (self.angles == .zero) {
                self._angles = GraffeineAnglePair(start: newAngles.start, end: newAngles.start)
            }

            let labelPoint = GraffeineAnglePair.point(for: newAngles.middle,
                                                      center: centerPoint,
                                                      radius: radius)

            self.alignment = distributedAlignment.graffeineRadialLabelAlignment(labelPoint: labelPoint,
                                                                                centerPoint: centerPoint)
            self.anchorPoint = deriveAnchorPoint()

            if let animator = animator {
                animator.animate(label: self,
                                 fromAngles: self.angles,
                                 toAngles: newAngles,
                                 labelPoint: labelPoint,
                                 centerPoint: centerPoint)
            } else {
                performWithoutAnimation {
                    self.position = labelPoint
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

        private func deriveAnchorPoint() -> CGPoint {
            let x: CGFloat
            switch self.alignment.horizontal {
            case .left:     x = 0
            case .right:    x = 1
            case .center:   x = 0.5
            }
            let y: CGFloat
            switch self.alignment.vertical {
            case .top:      y = 0
            case .bottom:   y = 1
            case .center:   y = 0.5
            }
            return CGPoint(x: x, y: y)
        }

        override public init() {
            super.init()
            self.backgroundColor = UIColor.clear.cgColor
            self.foregroundColor = UIColor.darkGray.cgColor
            self.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.fontSize = 12
            self.string = ""
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
                self.distributedAlignment = layer.distributedAlignment
                self._angles = layer.angles
            }
        }
    }
}
