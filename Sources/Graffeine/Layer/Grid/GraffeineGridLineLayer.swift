import UIKit

open class GraffeineGridLineLayer: GraffeineLayer {

    public var thickness: CGFloat = 0.5
    public var dashPattern: [NSNumber]? = nil
    public var dashPhase: CGFloat = 0

    override open func generateSublayers() {
        let baseline = self.bounds.size.height
        for _ in data.values {
            let layer = GridLine(yPos: baseline, flipXY: flipXY)
            addSublayer(layer)
        }
    }

    override open func repositionSublayers() {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }

        for (index, line) in sublayers.enumerated() {
            guard let line = line as? GridLine else { continue }

            line.strokeColor = safeIndexedColor(index)
            line.lineWidth = thickness
            line.lineDashPattern = dashPattern
            line.lineDashPhase = dashPhase
            line.reposition(for: index, in: data, containerSize: bounds.size)
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

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.thickness = layer.thickness
            self.dashPattern = layer.dashPattern
            self.dashPhase = layer.dashPhase
        }
    }

    override open func additionalConfig(_ conf: (GraffeineGridLineLayer) -> ()) -> GraffeineGridLineLayer {
        conf(self)
        return self
    }
}
