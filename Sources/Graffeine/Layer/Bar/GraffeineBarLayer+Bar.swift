import UIKit

extension GraffeineBarLayer {

    open class Bar: CALayer {

        public struct Subdivision {
            public let index: Int
            public let width: GraffeineLayer.DimensionalUnit
            public init(index: Int, width: GraffeineLayer.DimensionalUnit) {
                self.index = index
                self.width = width
            }
        }

        open var subdivision: Subdivision? = nil

        open var flipXY: Bool = false

        open func reposition(for index: Int,
                             in data: Data,
                             barWidth: GraffeineLayer.DimensionalUnit,
                             barMargin: CGFloat,
                             containerSize: CGSize,
                             animated: Bool,
                             duration: TimeInterval,
                             timing: CAMediaTimingFunctionName) {

            guard let valueHi = data.valuesHi[index] else {
                self.frame.size.width = 1.0
                self.frame.size.height = 0.0
                self.position = CGPoint(x: 0, y: 0)
                return
            }

            let valueLo = data.loValueOrZero(index)
            let maxValue = data.valueMax
            let translatedContainerSize = translatedSize(containerSize)

            let shouldConsiderLo: Bool = (valueLo > 0 && valueLo <= maxValue)
            let hiPercent: CGFloat = (valueHi <= maxValue) ? CGFloat(valueHi / maxValue) : 1.0
            let loPercent: CGFloat = (shouldConsiderLo) ? CGFloat(valueLo / maxValue) : 0.0
            let loPercentInverted: CGFloat = (shouldConsiderLo) ? ((1.0 - loPercent)) : 1.0
            let loPercentPositionMultiplier = (flipXY) ? loPercent : loPercentInverted

            var width = barWidth.resolved(within: translatedContainerSize.width,
                                          numberOfUnits: data.valuesHi.count,
                                          unitMargin: barMargin)
            let height = translatedContainerSize.height * (hiPercent - loPercent)

            var xPos = (CGFloat(index) * (width + barMargin))
            let yPos: CGFloat = translatedContainerSize.height * loPercentPositionMultiplier

            if let subdivision = self.subdivision {
                width = subdivision.width.resolved(within: width)
                xPos += (CGFloat(subdivision.index) * width)
            }

            self.anchorPoint = translatedAnchor(CGPoint(x: 0.0, y: 1.0))
            self.frame.size = translatedSize(CGSize(width: width, height: height))
            self.position = translatedPosition(CGPoint(x: xPos, y: yPos))
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

        private func translatedAnchor(_ point: CGPoint) -> CGPoint {
            return (flipXY)
                ? CGPoint(x: 1.0 - point.y, y: point.x)
                : point
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.backgroundColor = UIColor.black.cgColor
            self.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
            self.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        }

        public convenience init(yPos: CGFloat, subdivision: Subdivision?, flipXY: Bool) {
            self.init()
            self.frame.origin.y = yPos
            self.flipXY = flipXY
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.subdivision = layer.subdivision
                self.flipXY = layer.flipXY
            }
        }
    }
}
