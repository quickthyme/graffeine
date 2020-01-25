import UIKit

extension GraffeinePlotLayer {

    open class Plot: CAShapeLayer {

        public var diameter: CGFloat = 0.0

        open func reposition(for index: Int,
                             in data: GraffeineData,
                             unitWidth: GraffeineLayer.DimensionalUnit,
                             unitMargin: CGFloat,
                             containerSize: CGSize,
                             animator: GraffeinePlotDataAnimating?) {

            guard let value = data.values[index] else {
                performWithoutAnimation {
                    self.opacity = 0.0
                    self.position = .zero
                }
                return
            }

            let valPercent: CGFloat = getPercent(of: value, in: data.valueMaxOrHighest)

            let numberOfUnitsAdjustedForPlotOffset = data.values.count - 1

            let width = unitWidth.resolved(within: containerSize.width,
                                           numberOfUnits: numberOfUnitsAdjustedForPlotOffset,
                                           unitMargin: unitMargin)

            let newPosition = CGPoint(
                x: (CGFloat(index) * (width + unitMargin)),
                y: containerSize.height - (containerSize.height * valPercent)
            )

            let newRadius = (diameter / 2)

            let newPath = UIBezierPath(arcCenter: newPosition,
                                       radius: newRadius,
                                       startAngle: 0,
                                       endAngle: DegreesToRadians(360),
                                       clockwise: true).cgPath

            if let animator = animator {
                animator.animate(plot: self,
                                 fromPath: self.path ?? newPath,
                                 toPath: newPath)
            } else {
                performWithoutAnimation {
                    self.path = newPath
                    self.opacity = 1.0
                }
            }
        }

        func getPercent(of value: Double, in maxValue: Double) -> CGFloat {
            return (value < maxValue) ? CGFloat(value / maxValue) : 1.0
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.position = .zero
            self.opacity = 0
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Plot {
                self.diameter = layer.diameter
            }
        }
    }
}
