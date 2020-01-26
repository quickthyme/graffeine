import UIKit

extension GraffeineHorizontalLabelLayer {

    open class Label: GraffeineLabel {

        public var unitColumn: UnitColumn = UnitColumn()

        open func reposition(for index: Int,
                             in labels: [String?],
                             containerSize: CGSize) {

            let labelsCount = labels.count
            let labelValue = (index < labelsCount) ? (labels[index] ?? "") : ""

            let width = unitColumn.resolvedWidth(within: containerSize.width,
                                                 numberOfUnits: labels.count)
            let xPos = unitColumn.resolvedOffset(index: index, actualWidth: width)

            let newFrame = CGRect(x: xPos, y: 0, width: width, height: containerSize.height)

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
