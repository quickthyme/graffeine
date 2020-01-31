import UIKit

extension GraffeinePlotLabelLayer {

    open class Label: CATextLayer {

        public var unitColumn: UnitColumn = UnitColumn()
        public var diameter: CGFloat = 0.0

        open func reposition(for index: Int,
                             in data: GraffeineData,
                             containerSize: CGSize,
                             animator: GraffeinePlotLabelDataAnimating?) {

            guard (0..<data.labels.count ~= index),
                let value = data.values[index] else {
                    performWithoutAnimation {
                        self.opacity = 0.0
                        self.string = ""
                        self.position = .zero
                    }
                    return
            }

            let labelValue = data.preferredLabelValue(index)

            let valPercent: CGFloat = GraffeineData.getPercent(of: value, in: data.valueMaxOrHighest)

            let numberOfUnitsAdjustedForPlotOffset = data.values.count - 1

            let width = unitColumn.resolvedWidth(within: containerSize.width,
                                                 numberOfUnits: numberOfUnitsAdjustedForPlotOffset)

            let newPosition = CGPoint(
                x: unitColumn.resolvedOffset(index: index, actualWidth: width),
                y: containerSize.height - (containerSize.height * valPercent)
            )

            if let animator = animator {
                animator.animate(label: self, toValue: labelValue, toPosition: newPosition)
            } else {
                performWithoutAnimation {
                    self.string = labelValue
                    self.frame.size = preferredFrameSize()
                    self.position = newPosition
                    self.opacity = 1.0
                }
            }
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.position = .zero
            self.opacity = 0
            self.alignmentMode = .center
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Label {
                self.unitColumn = layer.unitColumn
                self.diameter = layer.diameter
            }
        }
    }
}
