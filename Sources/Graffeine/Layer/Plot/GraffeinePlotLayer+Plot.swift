import UIKit

extension GraffeinePlotLayer {

    open class Plot: CAShapeLayer {

        public var diameter: CGFloat = 0.0

        open func reposition(for index: Int,
                             in data: Data,
                             unitWidth: GraffeineLayer.DimensionalUnit,
                             unitMargin: CGFloat,
                             containerSize: CGSize) {

            guard let value = data.values[index] else {
                self.isHidden = true
                self.position = CGPoint(x: 0, y: 0)
                return
            }
            self.isHidden = false

            self.frame.size = CGSize(width: diameter, height: diameter)

            self.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: diameter, height: diameter),
                                     cornerRadius: diameter / 2).cgPath

            let valPercent: CGFloat = getPercent(of: value, in: data.valueMax)

            let numberOfUnitsAdjustedForPlotOffset = data.values.count - 1

            let width = unitWidth.resolved(within: containerSize.width,
                                           numberOfUnits: numberOfUnitsAdjustedForPlotOffset,
                                           unitMargin: unitMargin)

            let yPos = containerSize.height - (containerSize.height * valPercent)
            let xPos = (CGFloat(index) * (width + unitMargin))

            self.position = CGPoint(x: xPos, y: yPos)
        }

        func getPercent(of value: Double, in maxValue: Double) -> CGFloat {
            return (value < maxValue) ? CGFloat(value / maxValue) : 1.0
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.position = CGPoint(x: 0.0, y: 0.0)
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
