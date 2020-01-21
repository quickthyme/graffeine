import UIKit

extension GraffeineLineLayer {

    open class Line: CAShapeLayer {

        open func reposition(data: GraffeineData,
                             unitWidth: GraffeineLayer.DimensionalUnit,
                             unitMargin: CGFloat,
                             containerSize: CGSize,
                             animator: GraffeineLineDataAnimating?) {
            self.frame.size = containerSize

            let newPath = pathForLine(data: data,
                                      unitWidth: unitWidth,
                                      unitMargin: unitMargin,
                                      containerSize: containerSize)

            if let animator = animator {
                let oldPath = self.presentation()?.path
                    ?? self.path
                    ?? newPath
                animator.animate(line: self, from: oldPath, to: newPath)
            } else {
                performWithoutAnimation {
                    self.path = newPath
                }
            }
        }

        func getPercent(of value: Double, in maxValue: Double) -> CGFloat {
            return (value < maxValue) ? CGFloat(value / maxValue) : 1.0
        }

        func pathForLine(data: GraffeineData,
                         unitWidth: GraffeineLayer.DimensionalUnit,
                         unitMargin: CGFloat,
                         containerSize: CGSize) -> CGPath {
            guard (!data.values.isEmpty) else { return CGPath(rect: .zero, transform: nil) }

            let maxValue = data.valueMaxOrHighest

            let path = UIBezierPath()

            var lastValueWasNil: Bool = true

            for (index, value) in data.values.enumerated() {
                guard let value = value else {
                    lastValueWasNil = true
                    continue
                }

                let valPercent: CGFloat = getPercent(of: value, in: maxValue)

                let numberOfUnitsAdjustedForLineOffset = data.values.count - 1

                let width = unitWidth.resolved(within: containerSize.width,
                                               numberOfUnits: numberOfUnitsAdjustedForLineOffset,
                                               unitMargin: unitMargin)

                let yPos = containerSize.height - (containerSize.height * valPercent)
                let xPos = (CGFloat(index) * (width + unitMargin))
                let point = CGPoint(x: xPos, y: yPos)

                if (lastValueWasNil) {
                    lastValueWasNil = false
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }

            return path.cgPath
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            self.fillColor = nil
            self.path = nil
            self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.position = CGPoint(x: 0.0, y: 0.0)
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
        }
    }
}
