import UIKit

extension GraffeinePieLayer {

    open class PieSlice: CAShapeLayer {

        open var clockwise: Bool = true
        open var rotation: UInt = 0

        open func reposition(for index: Int,
                             in percentages: [CGFloat],
                             radius: CGFloat,
                             centerPoint: CGPoint) {
            let rotAngle = rotationAngle()
            let pctAngle = percentAngle(percentages[index])
            let startAngle = startingAngle(for: index, in: percentages) + rotAngle
            let endAngle = startAngle + pctAngle

            self.path = pathForSlice(centerPoint: centerPoint,
                                     radius: radius,
                                     startAngle: startAngle,
                                     endAngle: endAngle)
        }

        private func degToRad(_ deg: CGFloat) -> CGFloat {
            return (deg * CGFloat.pi / 180)
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

        private func pathForSlice(centerPoint: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> CGPath? {
            let path = UIBezierPath(arcCenter: centerPoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: clockwise)
            path.addLine(to: centerPoint)
            path.close()
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
            }
        }
    }
}
