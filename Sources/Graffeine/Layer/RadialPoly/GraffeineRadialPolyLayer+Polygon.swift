import UIKit

extension GraffeineRadialPolyLayer {

    open class Polygon: CAShapeLayer {

        public var rotation: Int = 0
        public var maxRadius: CGFloat = 0

        public func constructPath(radii: [CGFloat],
                                  angles: [GraffeineAnglePair],
                                  centerPoint: CGPoint) -> CGPath {
            let radiiCount  = radii.count
            let anglesCount = angles.count
            let path = UIBezierPath()

            guard (radiiCount > 0 && radiiCount == anglesCount)
                else { return UIBezierPath().cgPath }

            let points: [CGPoint] = radii.enumerated().map {
                let anglePair = angles[$0.offset]
                return GraffeineAnglePair.point(for: anglePair.middle,
                                                center: centerPoint,
                                                radius: $0.element)
            }

            path.move(to: points[0])
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
            path.close()

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
                self.rotation = layer.rotation
                self.maxRadius = layer.maxRadius
            }
        }
    }
}
