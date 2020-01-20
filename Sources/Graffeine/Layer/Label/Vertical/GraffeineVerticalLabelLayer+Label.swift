import UIKit

extension GraffeineVerticalLabelLayer {

    open class Label: CATextLayer {

        open var hPadding: CGFloat = 4.0
        open var vPadding: CGFloat = 0.0
        open var horizontalAlignmentMode: LabelAlignment.HorizontalMode = .right
        open var verticalAlignmentMode: LabelAlignment.VerticalMode = .centerTopBottom

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
                    performWithoutAnimation {
                        self.frame.size.width = 1.0
                        self.frame.size.height = 0.0
                        self.position = CGPoint(x: 0, y: 0)
                    }
                    return
            }

            let height = rowHeight.resolved(within: containerSize.height,
                                            numberOfUnits: labels.count,
                                            unitMargin: rowMargin)

            let yOffset = verticalAlignmentMode.calculateYOffset(for: index,
                                                                 in: labels,
                                                                 fontSize: fontSize,
                                                                 padding: vPadding,
                                                                 within: height)

            let yPos = (CGFloat(index) * (height + rowMargin)) + yOffset
            let xPos = (alignmentMode == .left) ? hPadding : 0.0

            performWithoutAnimation {
                self.alignmentMode = horizontalAlignmentMode.textAlignment(for: index, in: labels)
                self.string = labelValue
                self.frame.size.height = height
                self.frame.size.width = containerSize.width - hPadding
                self.position = CGPoint(x: xPos, y: yPos)
            }
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

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.hPadding = layer.hPadding
                self.vPadding = layer.vPadding
                self.horizontalAlignmentMode = layer.horizontalAlignmentMode
                self.verticalAlignmentMode = layer.verticalAlignmentMode
            }
        }
    }
}
