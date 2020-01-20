import UIKit

extension GraffeineBarLayer {

    open class Bar: CAShapeLayer {

        public var subdivision: UnitSubdivision? = nil
        public var flipXY: Bool = false
        public var roundedEnds: RoundedEnds = .none

        open func reposition(for index: Int,
                             in data: GraffeineData,
                             unitWidth: GraffeineLayer.DimensionalUnit,
                             unitMargin: CGFloat,
                             containerSize: CGSize,
                             animator: GraffeineBarDataAnimating?) {

            let drawingInfo = Calc.drawingInfo(valueHi: data.valuesHi[index] ?? 0,
                                               valueLo: data.loValueOrZero(index),
                                               maxValue: data.valueMax,
                                               unitIndex: index,
                                               numberOfUnits: data.valuesHi.count,
                                               unitWidth: unitWidth,
                                               unitMargin: unitMargin,
                                               subdivision: subdivision,
                                               containerSize: containerSize,
                                               flipXY: flipXY)

            let oldBarFrame: CGRect = self.path?.boundingBoxOfPath ?? .zero
            let oldOrigin = oldBarFrame.origin
            let oldSize = oldBarFrame.size

            let newOrigin = drawingInfo.origin
            let newSize = drawingInfo.size

            if let animator = animator {
                animator.animate(bar: self,
                                 fromOrigin: oldOrigin,
                                 toOrigin: newOrigin,
                                 fromSize: oldSize,
                                 toSize: newSize)
            } else {
                performWithoutAnimation {
                    self.path = constructPath(origin: newOrigin, size: newSize)
                }
            }
        }

        open func constructPath(origin: CGPoint, size: CGSize) -> CGPath {
            let frame = CGRect(origin: origin, size: size)

            let path = UIBezierPath(roundedRect: frame,
                                    byRoundingCorners: roundedEnds.translatedRoundingCorners(flipXY),
                                    cornerRadii: roundedEnds.cornerRadii())
            return path.cgPath
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.backgroundColor = UIColor.clear.cgColor
            self.fillColor = UIColor.black.cgColor
            self.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
            self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.subdivision = layer.subdivision
                self.flipXY = layer.flipXY
                self.roundedEnds = layer.roundedEnds
            }
        }
    }
}
