import UIKit

extension GraffeineGridLineLayer {

    open class GridLine: CAShapeLayer {

        open var flipXY: Bool = false

        open func reposition(for index: Int,
                             in data: GraffeineData,
                             containerSize: CGSize) {

            guard let value = data.values.hi[index] else {
                performWithoutAnimation {
                    self.frame.size.width = 1.0
                    self.frame.size.height = 0.0
                    self.position = CGPoint(x: 0, y: 0)
                }
                return
            }

            let translatedContainerSize = translatedSize(containerSize)
            let maxVal = data.valueMaxOrHighestHi

            let valPercentInverted: CGFloat = (value <= maxVal)
                ? 1.0 - CGFloat(value / maxVal)
                : 0.0

            let yPos: CGFloat = translatedContainerSize.height * valPercentInverted

            performWithoutAnimation {
                self.anchorPoint = translatedAnchor(yPos, translatedContainerSize)
                self.frame.size = translatedSize( CGSize(width: translatedContainerSize.width, height: 0.0) )
                self.path = pathForLine().cgPath
                self.position = translatedPosition(
                    thicknessOffset(CGPoint(x: 0, y: translatedContainerSize.height * valPercentInverted),
                                    translatedContainerSize)
                )
            }
        }

        private func translatedSize(_ size: CGSize) -> CGSize {
            return (flipXY)
                ? CGSize(width: size.height, height: size.width)
                : size
        }

        private func translatedPosition(_ point: CGPoint) -> CGPoint {
            return (flipXY)
                ? CGPoint(x: point.y, y: point.x)
                : point
        }

        private func translatedAnchor(_ yPos: CGFloat, _ containerSize: CGSize) -> CGPoint {
            let yPosInt = Int( ceil(yPos) )
            let containerHeightInt = Int( ceil(containerSize.height) )
            switch true {
            case (yPosInt == 0):
                return (flipXY) ? CGPoint(x: 1.0, y: 0.0) : CGPoint(x: 0.0, y: 0.0)
            case (yPosInt == containerHeightInt):
                return (flipXY) ? CGPoint(x: 0.0, y: 0.0) : CGPoint(x: 0.0, y: 1.0)
            default:
                return (flipXY) ? CGPoint(x: 0.5, y: 0.0) : CGPoint(x: 0.0, y: 0.5)
            }
        }

        private func thicknessOffset(_ point: CGPoint, _ containerSize: CGSize) -> CGPoint {
            let yPosInt = Int( ceil(point.y) )
            let containerHeightInt = Int( ceil(containerSize.height) )
            let halfWidth = lineWidth * 0.5
            switch true {
            case (yPosInt == 0):
                return CGPoint(x: point.x, y: point.y + halfWidth)
            case (yPosInt == containerHeightInt):
                return CGPoint(x: point.x, y: point.y - halfWidth)
            default:
                return point
            }
        }

        func pathForLine() -> UIBezierPath{
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
            return path
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.anchorPoint   = CGPoint(x: 0, y: 0)
            self.frame         = CGRect(x: 0, y: 0, width: 1, height: 0)
            self.fillColor     = nil
            self.path          = pathForLine().cgPath
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.flipXY = layer.flipXY
            }
        }
    }
}
