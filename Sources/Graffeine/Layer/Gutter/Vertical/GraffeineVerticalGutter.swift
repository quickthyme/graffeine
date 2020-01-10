import UIKit

open class GraffeineVerticalGutter: GraffeineLayer {

    open var rowHeight: GraffeineLayer.DimensionalUnit = .relative
    open var rowMargin: CGFloat = 4.0
    open var fontSize: CGFloat = 10.0
    open var labelHPadding: CGFloat = 4.0
    open var labelVPadding: CGFloat = 0.0
    open var labelHorizontalAlignmentMode: LabelAlignment.HorizontalMode = .right
    open var labelVerticalAlignmentMode: LabelAlignment.VerticalMode = .centerTopBottom

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
            label.fontSize = fontSize
            label.verticalAlignmentMode = labelVerticalAlignmentMode
            label.hPadding = labelHPadding
            label.vPadding = labelVPadding
            label.reposition(for: index,
                             in: data.labels,
                             rowHeight: rowHeight,
                             rowMargin: rowMargin,
                             containerSize: bounds.size)
        }
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
    }

    public convenience init(id: AnyHashable, width: CGFloat, region: Region = .leftGutter) {
        self.init()
        self.id = id
        self.region = region
        self.frame = CGRect(x: 0, y: 0, width: width, height: 100)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.rowHeight = layer.rowHeight
            self.rowMargin = layer.rowMargin
            self.fontSize = layer.fontSize
            self.labelHPadding = layer.labelHPadding
            self.labelVPadding = layer.labelVPadding
            self.labelHorizontalAlignmentMode = layer.labelHorizontalAlignmentMode
            self.labelVerticalAlignmentMode = layer.labelVerticalAlignmentMode
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineVerticalGutter) -> ()) -> GraffeineVerticalGutter {
        conf(self)
        return self
    }
}
