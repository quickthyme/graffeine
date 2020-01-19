import UIKit

extension GraffeineBarLayer {

    open class Bar: CALayer {

        open var subdivision: UnitSubdivision? = nil

        open var flipXY: Bool = false

        open func reposition(for index: Int,
                             in data: GraffeineData,
                             unitWidth: GraffeineLayer.DimensionalUnit,
                             unitMargin: CGFloat,
                             containerSize: CGSize,
                             animator: GraffeineBarDataAnimating?) {

            let valueHi = data.valuesHi[index] ?? 0
            let valueLo = data.loValueOrZero(index)
            let maxValue = data.valueMax
            let translatedContainerSize = translatedSize(containerSize)

            let shouldConsiderLo: Bool = (valueLo > 0 && valueLo <= maxValue)
            let hiPercent: CGFloat = (valueHi <= maxValue) ? CGFloat(valueHi / maxValue) : 1.0
            let loPercent: CGFloat = (shouldConsiderLo) ? CGFloat(valueLo / maxValue) : 0.0
            let loPercentInverted: CGFloat = (shouldConsiderLo) ? ((1.0 - loPercent)) : 1.0
            let loPercentPositionMultiplier = (flipXY) ? loPercent : loPercentInverted

            var width = unitWidth.resolved(within: translatedContainerSize.width,
                                           numberOfUnits: data.valuesHi.count,
                                           unitMargin: unitMargin)
            let height = translatedContainerSize.height * (hiPercent - loPercent)

            var xPos = (CGFloat(index) * (width + unitMargin))
            let yPos: CGFloat = translatedContainerSize.height * loPercentPositionMultiplier

            if let subdivision = self.subdivision {
                width = subdivision.width.resolved(within: width)
                xPos += (CGFloat(subdivision.index) * width)
            }

            self.anchorPoint = translatedAnchor(CGPoint(x: 0.0, y: 1.0))
            let oldPosition = self.position
            let newPosition = translatedPosition(CGPoint(x: xPos, y: yPos))
            let oldSize = self.frame.size
            let newSize = translatedSize(CGSize(width: width, height: height))

            if let animator = animator {
                animator.animate(bar: self,
                                 fromPosition: oldPosition,
                                 toPosition: newPosition,
                                 fromSize: oldSize,
                                 toSize: newSize)
            } else {
                performWithoutAnimation {
                    self.position = newPosition
                    self.frame.size = newSize
                }
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
