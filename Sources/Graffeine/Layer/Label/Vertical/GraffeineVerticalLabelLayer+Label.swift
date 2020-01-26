import UIKit

extension GraffeineVerticalLabelLayer {

    open class Label: GraffeineLabel {

        public var unitColumn: UnitColumn = UnitColumn()

        open func reposition(for index: Int,
                             in labels: [String?],
                             rowHeight: GraffeineLayer.DimensionalUnit,
                             rowMargin: CGFloat,
                             containerSize: CGSize) {

            let labelsCount = labels.count
            let labelValue = (index < labelsCount) ? (labels[index] ?? "") : ""


            let height = rowHeight.resolved(within: containerSize.height,
                                            numberOfUnits: labels.count,
                                            unitMargin: rowMargin)

            let yPos = (CGFloat(index) * (height + rowMargin))

            let newFrame = CGRect(x: 0, y: yPos, width: containerSize.width, height: height)

            performWithoutAnimation {
                self.string = labelValue
                self.frame = newFrame
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
            }
        }
    }
}
