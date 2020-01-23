import UIKit

extension GraffeineHorizontalLabelLayer {

    open class Label: CATextLayer {

        open var hPadding: CGFloat = 4.0
        open var vPadding: CGFloat = 0.0
        open var horizontalAlignmentMode: LabelAlignment.HorizontalMode = .centerLeftRight
        open var verticalAlignmentMode: LabelAlignment.VerticalMode = .center

        open func reposition(for index: Int,
                             in labels: [String?],
                             columnWidth: GraffeineLayer.DimensionalUnit,
                             columnMargin: CGFloat,
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

            let width = columnWidth.resolved(within: containerSize.width,
                                             numberOfUnits: labels.count,
                                             unitMargin: columnMargin)

            let xPos = (CGFloat(index) * (width + columnMargin)) + calculateXPaddingOffset()
            let yPos = verticalAlignmentMode.calculateYOffset(for: index,
                                                              in: labels,
                                                              fontSize: fontSize,
                                                              padding: vPadding,
                                                              within: containerSize.height)
            var frameSize = preferredFrameSize()
            frameSize.width = width

            performWithoutAnimation {
                self.string = labelValue
                self.alignmentMode = horizontalAlignmentMode.textAlignment(for: index, in: labels)
                self.frame.size = frameSize
                self.position = CGPoint(x: xPos, y: yPos)
            }
        }

        func calculateXPaddingOffset() -> CGFloat {
            switch horizontalAlignmentMode {
            case .left:     return hPadding
            case .right:    return -hPadding
            default:        return 0.0
            }
        }

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.backgroundColor = UIColor.clear.cgColor
            self.foregroundColor = UIColor.darkGray.cgColor
            self.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
            self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.fontSize = 12
            self.alignmentMode = .left
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
