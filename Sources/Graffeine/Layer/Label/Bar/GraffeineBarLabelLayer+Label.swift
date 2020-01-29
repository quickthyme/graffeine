import UIKit

extension GraffeineBarLabelLayer {

    open class Label: GraffeineLabel {

        public var unitColumn: UnitColumn = UnitColumn()
        public var flipXY: Bool = false

        open func reposition(for index: Int,
                             in data: GraffeineData,
                             alignment: Alignment,
                             padding: Padding,
                             containerSize: CGSize,
                             animator: GraffeineLabelDataAnimating?) {

            let labelValue = data.preferredLabelValue(index)
            let drawingInfo = unitColumn.drawingInfo(valueHi: data.valuesHi[index] ?? 0,
                                                     valueLo: data.loValueOrZero(index),
                                                     maxValue: data.valueMaxOrHighest,
                                                     unitIndex: index,
                                                     numberOfUnits: data.valuesHi.count,
                                                     containerSize: containerSize,
                                                     flipXY: flipXY)
            if let animator = animator {
                animator.animate(label: self,
                                 toValue: labelValue,
                                 toFrame: CGRect(origin: drawingInfo.origin,
                                                 size: drawingInfo.size),
                                 toAlignment: alignment,
                                 toPadding: padding)
            } else {
                performWithoutAnimation {
                    self.string = labelValue
                    self.position = drawingInfo.origin
                    self.bounds = CGRect(origin: .zero, size: drawingInfo.size)
                    self.alignment = alignment
                    self.padding = padding
                }
            }
        }

        override public init() {
            super.init()
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.unitColumn = layer.unitColumn
                self.flipXY = layer.flipXY
            }
        }
    }
}
