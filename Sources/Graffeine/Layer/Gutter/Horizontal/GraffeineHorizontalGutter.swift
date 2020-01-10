import UIKit

open class GraffeineHorizontalGutter: GraffeineLayer {

    open var columnWidth: GraffeineLayer.DimensionalUnit = .relative
    open var columnMargin: CGFloat = 4.0
    open var fontSize: CGFloat = 10.0
    open var labelHPadding: CGFloat = 4.0
    open var labelVPadding: CGFloat = 0.0
    open var labelHorizontalAlignmentMode: LabelAlignment.HorizontalMode = .centerLeftRight
    open var labelVerticalAlignmentMode: LabelAlignment.VerticalMode = .center

    override open func generateSublayers() {
        for _ in data.labels {
            addSublayer( Label(fontSize: fontSize,
                               hPadding: labelHPadding,
                               vPadding: labelVPadding,
                               horizontalAlignmentMode: labelHorizontalAlignmentMode,
                               verticalAlignmentMode: labelVerticalAlignmentMode) )
        }
    }

    override open func repositionSublayers() {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.labels.count

        for (index, label) in sublayers.enumerated() {
            guard let label = label as? Label, index < numberOfUnits else { continue }

            label.foregroundColor = safeIndexedColor(index)
            label.hPadding = labelHPadding
            label.vPadding = labelVPadding
            label.horizontalAlignmentMode = labelHorizontalAlignmentMode
            label.reposition(for: index,
                             in: data.labels,
                             columnWidth: columnWidth,
                             columnMargin: columnMargin,
                             containerSize: bounds.size)
        }
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
    }

    public convenience init(id: AnyHashable, height: CGFloat, region: Region = .bottomGutter) {
        self.init()
        self.id = id
        self.region = region
        self.frame = CGRect(x: 0, y: 0, width: 100, height: height)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.columnWidth = layer.columnWidth
            self.columnMargin = layer.columnMargin
            self.fontSize = layer.fontSize
            self.labelHPadding = layer.labelHPadding
            self.labelVPadding = layer.labelVPadding
            self.labelHorizontalAlignmentMode = layer.labelHorizontalAlignmentMode
            self.labelVerticalAlignmentMode = layer.labelVerticalAlignmentMode
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineHorizontalGutter) -> ()) -> GraffeineHorizontalGutter {
        conf(self)
        return self
    }
}
