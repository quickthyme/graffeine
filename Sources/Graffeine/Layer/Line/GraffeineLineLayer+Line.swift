import UIKit

extension GraffeineLineLayer {

    open class Line: CAShapeLayer {

        open func reposition(data: Data,
                             unitWidth: GraffeineLayer.DimensionalUnit,
                             unitMargin: CGFloat,
                             containerSize: CGSize) {

            guard
                let path = pathForLine(data: data,
                                       unitWidth: unitWidth,
                                       unitMargin: unitMargin,
                                       containerSize: containerSize)
                else {
                    self.path = nil
                    self.position = CGPoint(x: 0, y: 0)
                    return
            }

            self.frame.size = containerSize
            self.path = path.cgPath
        }


        func getPercent(of value: Double, in maxValue: Double) -> CGFloat {
            return (value < maxValue) ? CGFloat(value / maxValue) : 1.0
        }

        func pathForLine(data: Data,
                         unitWidth: GraffeineLayer.DimensionalUnit,
                         unitMargin: CGFloat,
                         containerSize: CGSize) -> UIBezierPath? {
            guard (!data.values.isEmpty) else { return nil }

            let maxValue = data.valueMax

            let path = UIBezierPath()

            var lastValueWasNil: Bool = true

            for (index, value) in data.values.enumerated() {
                guard let value = value else {
                    lastValueWasNil = true
                    continue
                }

                let valPercent: CGFloat = getPercent(of: value, in: maxValue)

                let width = unitWidth.resolved(within: containerSize.width,
                                               numberOfUnits: data.values.count,
                                               unitMargin: unitMargin)
                let halfWidth = width * 0.5

                let yPos = containerSize.height - (containerSize.height * valPercent)
                let xPos = (CGFloat(index) * (width + unitMargin)) + halfWidth
                let point = CGPoint(x: xPos, y: yPos)

                if (lastValueWasNil) {
                    lastValueWasNil = false
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }

            return path
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
