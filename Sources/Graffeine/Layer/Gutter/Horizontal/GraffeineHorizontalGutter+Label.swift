import UIKit

extension GraffeineHorizontalGutter {

    open class Label: CATextLayer {

        open var padding: CGFloat = 4.0
        open var labelAlignmentMode: LabelAlignmentMode = .centerLeftRight

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
                    self.frame.size.width = 1.0
                    self.frame.size.height = 0.0
                    self.position = CGPoint(x: 0, y: 0)
                    return
            }

            let width = columnWidth.resolved(within: containerSize.width,
                                             numberOfUnits: labels.count,
                                             unitMargin: columnMargin)
            let xPos = (CGFloat(index) * (width + columnMargin))

            self.string = labelValue
            self.alignmentMode = textAlignment(for: index, in: labels)
            self.frame.size.height = containerSize.height
            self.frame.size.width = width
            self.position = CGPoint(x: xPos, y: 2)
        }

        private let textLabelAlignmentMap: [LabelAlignmentMode: CATextLayerAlignmentMode] = [
            .left: .left,
            .right: .right,
            .center: .center
        ]

        private func textAlignment(for index: Int, in labels: [String?]) -> CATextLayerAlignmentMode {
            return textLabelAlignmentMap[labelAlignmentMode]
                ?? centerLeftRightTextAlignment(for: index, in: labels)
        }

        private func centerLeftRightTextAlignment(for index: Int, in labels: [String?]) -> CATextLayerAlignmentMode {
            switch true {
            case (index == 0):
                return .left
            case (index == labels.count - 1):
                return .right
            default:
                return .center
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

        public convenience init(fontSize: CGFloat, padding: CGFloat, labelAlignmentMode: LabelAlignmentMode) {
            self.init()
            self.fontSize = fontSize
            self.padding = padding
            self.labelAlignmentMode = labelAlignmentMode
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.padding = layer.padding
                self.labelAlignmentMode = layer.labelAlignmentMode
            }
        }
    }
}
