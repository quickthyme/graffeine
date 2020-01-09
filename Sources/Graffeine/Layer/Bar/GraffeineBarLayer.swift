import UIKit

open class GraffeineBarLayer: GraffeineLayer {

    public var barWidth: GraffeineLayer.DimensionalUnit = .relative
    public var barMargin: CGFloat = 4.0

    override open func generateSublayers() {
        let baseline = self.bounds.size.height
        for _ in data.valuesHi { addSublayer( Bar(yPos: baseline, flipXY: flipXY) ) }
    }

    override open func repositionSublayers() {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.valuesHi.count

        for (index, bar) in sublayers.enumerated() {
            guard let bar = bar as? Bar, index < numberOfUnits else { continue }
            bar.backgroundColor = safeIndexedColor(index)
            bar.reposition(for: index,
                           in: data,
                           barWidth: barWidth,
                           barMargin: barMargin,
                           containerSize: bounds.size)
        }
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
            self.barWidth = layer.barWidth
            self.barMargin = layer.barMargin
        }
    }

    override open func additionalConfig(_ conf: (GraffeineBarLayer) -> ()) -> GraffeineBarLayer {
        conf(self)
        return self
    }
}
