import UIKit

extension GraffeineLineLayer {

    open class Line: CAShapeLayer {

        public var unitColumn: UnitColumn = UnitColumn()

        func constructLinePath(values: [Double?],
                               maxValue: Double,
                               containerSize: CGSize,
                               smoothing: Smoothing) -> CGPath {
            guard
                (!values.isEmpty)
                else { return CGPath(rect: .zero, transform: nil) }

            var path = UIBezierPath()

            draw(values: values,
                 maxValue: maxValue,
                 path: &path,
                 unitColumn: unitColumn,
                 containerSize: containerSize,
                 startsWith: nil,
                 drawThroughNil: false,
                 reverse: false)

            return applySmoothingIfDesired(smoothing, to: path).cgPath
        }

        func constructFillPath(valuesTop: [Double?],
                               valuesBottom: [Double?],
                               maxValue: Double,
                               containerSize: CGSize,
                               smoothing: Smoothing) -> CGPath {
            guard
                (!valuesTop.isEmpty)
                else { return CGPath(rect: .zero, transform: nil) }

            let valuesBottom: [Double?] = (valuesBottom.isEmpty)
                ? valuesTop.map { _ in return 0 }
                : valuesBottom

            var path = UIBezierPath()

            draw(values: valuesTop,
                 maxValue: maxValue,
                 path: &path,
                 unitColumn: unitColumn,
                 containerSize: containerSize,
                 startsWith: nil,
                 drawThroughNil: false,
                 reverse: false)

            draw(values: valuesBottom,
                 maxValue: maxValue,
                 path: &path,
                 unitColumn: unitColumn,
                 containerSize: containerSize,
                 startsWith: valuesTop.last ?? 0,
                 drawThroughNil: true,
                 reverse: true)

            path.close()

            return applySmoothingIfDesired(smoothing, to: path).cgPath
        }

        func draw(values: [Double?],
                  maxValue: Double,
                  path: inout UIBezierPath,
                  unitColumn: GraffeineLayer.UnitColumn,
                  containerSize: CGSize,
                  startsWith: Double?,
                  drawThroughNil: Bool,
                  reverse: Bool) {

            func drawNextSegment(index: Int,
                                 value: Double?,
                                 lastValue: Double?) -> Double? {

                guard let value = value else { return nil }

                let lastValueWasNil = (lastValue == nil)

                let valPercent: CGFloat = GraffeineData.getPercent(of: value, in: maxValue)

                let width = unitColumn.resolvedWidth(within: containerSize.width,
                                                     numberOfUnits: values.count)

                let yPos = containerSize.height - (containerSize.height * valPercent)

                let xPos = (CGFloat(index) * (width + unitColumn.margin))

                let point = CGPoint(x: xPos, y: yPos)

                if (lastValueWasNil && !drawThroughNil) {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
                return value
            }

            var lastValue: Double? = startsWith
            if reverse {
                for (index, value) in values.enumerated().reversed() {
                    lastValue = drawNextSegment(index: index, value: value, lastValue: lastValue)
                }
            } else {
                for (index, value) in values.enumerated() {
                    lastValue = drawNextSegment(index: index, value: value, lastValue: lastValue)
                }
            }
        }

        func applySmoothingIfDesired(_ smoothing: Smoothing, to path: UIBezierPath) -> UIBezierPath {
            switch (smoothing) {
            case .none:
                return path

            case let .catmullRom(granularity):
                return path.pathBySmoothing(method:
                    LineSmoothingMethodCatmullRom(granularity: granularity))

            case let .custom(smoother):
                return smoother.pathBySmoothing(in: path)
            }
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
            if let layer = layer as? Self {
                self.unitColumn = layer.unitColumn
            }
        }
    }
}
