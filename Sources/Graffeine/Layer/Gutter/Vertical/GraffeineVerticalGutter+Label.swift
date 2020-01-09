import UIKit

extension GraffeineVerticalGutter {

    open class Label: CATextLayer {

        var padding: CGFloat = 4.0

        open func reposition(for index: Int,
                             in labels: [String?],
                             rowHeight: GraffeineLayer.DimensionalUnit,
                             rowMargin: CGFloat,
                             containerSize: CGSize) {

            let labelsCount = labels.count

            guard
                (index < labelsCount),
                let labelValue = labels[index]
                else {
                    self.frame.size.width = 1.0
                    self.frame.size.height = 0.0
                    self.position = CGPoint(x: 0, y: 0)
                    return
            }

            let height = rowHeight.resolved(within: containerSize.height,
                                            numberOfUnits: labels.count,
                                            unitMargin: rowMargin)
            let yOffset = (height - self.fontSize - 1.0) * 0.5
            let yPos = (CGFloat(index) * (height + rowMargin)) + yOffset
            let xPos = (alignmentMode == .left) ? padding : 0.0

            self.string = labelValue
            self.frame.size.height = height
            self.frame.size.width = containerSize.width - padding
            self.position = CGPoint(x: xPos, y: yPos)
        }

        override public init() {
            super.init()
            self.masksToBounds = true
            self.contentsScale = UIScreen.main.scale
            self.backgroundColor = UIColor.clear.cgColor
            self.foregroundColor = UIColor.darkGray.cgColor
            self.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
            self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.fontSize = 12
            self.alignmentMode = .right
            self.string = ""
        }

        public convenience init(fontSize: CGFloat, alignmentMode: CATextLayerAlignmentMode, padding: CGFloat = 4.0) {
            self.init()
            self.fontSize = fontSize
            self.alignmentMode = alignmentMode
            self.padding = padding
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
        }
    }
}
