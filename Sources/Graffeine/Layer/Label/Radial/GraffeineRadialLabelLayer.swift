import UIKit

open class GraffeineRadialLabelLayer: GraffeineLayer {

    public var clockwise: Bool = true
    public var rotation: UInt = 0
    public var diameter: GraffeineLayer.DimensionalUnit = .percentage(0.9)
    public var fontSize: CGFloat = 10.0

    override open func generateSublayer() -> CALayer {
        return Label()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let centerPoint = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let numberOfLabels = data.values.count
        let total = data.valueMaxOrSum
        let percentages = data.values.map { CGFloat( ($0 ?? 0) / total ) }
        let radius = resolveRadius(diameter)

        for (index, label) in sublayers.enumerated() {
            guard let label = label as? Label, index < numberOfLabels else { continue }
            let text = labelValue(index, data)
            label.clockwise = clockwise
            label.rotation = rotation
            label.radius = radius
            label.fontSize = fontSize
            label.foregroundColor = safeIndexedColor(index)
            label.string = text
            unitShadow.apply(to: label)

            label.frame.size = label.preferredFrameSize()
            label.reposition(for: index,
                             in: percentages,
                             centerPoint: centerPoint,
                             animator: animator as? GraffeineRadialLabelDataAnimating)
        }
    }

    private func resolveRadius(_ diameter: GraffeineLayer.DimensionalUnit) -> CGFloat {
        let diameterBounds = min(bounds.size.width, bounds.size.height)
        let realDiameter = diameter.resolved(within: diameterBounds)
        return (realDiameter / 2)
    }

    private func labelValue(_ index: Int, _ data: GraffeineData) -> String {
        return (data.labels.count >= index) ? (data.labels[index] ?? "") : ("")
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
    }

    public convenience init(id: AnyHashable, region: Region = .main) {
        self.init()
        self.id = id
        self.region = region
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.clockwise = layer.clockwise
            self.rotation = layer.rotation
            self.diameter = layer.diameter
            self.fontSize = layer.fontSize
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineRadialLabelLayer) -> ()) -> GraffeineRadialLabelLayer {
        conf(self)
        return self
    }
}
