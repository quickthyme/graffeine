import UIKit

extension GraffeinePlotLayer {

    open class Plot: CAShapeLayer {

        public var diameter: CGFloat = 0.0

        open func reposition(for index: Int,
                             in data: Data,
                             unitWidth: GraffeineLayer.DimensionalUnit,
                             unitMargin: CGFloat,
                             containerSize: CGSize,
                             animated: Bool,
                             duration: TimeInterval,
                             animationDurationPercentDelay: Double,
                             timing: CAMediaTimingFunctionName) {

            guard let value = data.values[index] else {
                performWithoutAnimation {
                    self.opacity = 0.0
                    self.position = .zero
                }
                return
            }

            let valPercent: CGFloat = getPercent(of: value, in: data.valueMax)

            let numberOfUnitsAdjustedForPlotOffset = data.values.count - 1

            let width = unitWidth.resolved(within: containerSize.width,
                                           numberOfUnits: numberOfUnitsAdjustedForPlotOffset,
                                           unitMargin: unitMargin)

            let yPos = containerSize.height - (containerSize.height * valPercent)
            let xPos = (CGFloat(index) * (width + unitMargin))

            performWithoutAnimation {
                self.opacity = 0.0
                self.frame.size = CGSize(width: diameter, height: diameter)
                self.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: diameter, height: diameter),
                                         cornerRadius: diameter / 2).cgPath
                self.position = CGPoint(x: xPos, y: yPos)
                if (!animated) { self.opacity = 1.0 }
            }

            if (animated) {
                let delayKeyTime = NSNumber(value: animationDurationPercentDelay )
                let animation = CAKeyframeAnimation(keyPath: "opacity")
                animation.timingFunction  = CAMediaTimingFunction(name: timing)
                animation.duration = duration
                animation.values = [0.0, 0.0, 1.0]
                animation.keyTimes = [0.0, delayKeyTime, 1.0]
                animation.fillMode = .forwards
                self.add(animation, forKey: "reposition")
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
