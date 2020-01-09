import UIKit

open class GraffeineLineLayer: GraffeineLayer {

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative
    public var unitMargin: CGFloat = 4.0

    public var thickness: CGFloat = 0.5
    public var dashPattern: [NSNumber]? = nil
    public var dashPhase: CGFloat = 0
    public var lineJoin: CAShapeLayerLineJoin = .bevel

    override open func generateSublayers() {
        addSublayer( Line() )
    }

    override open func repositionSublayers() {
        guard let line = self.sublayers?.first(where: { $0 is Line }) as? Line
            else { return }
        line.strokeColor = safeIndexedColor(0)
        line.lineWidth = thickness
        line.lineDashPattern = dashPattern
        line.lineDashPhase = dashPhase
        line.lineJoin = lineJoin
        line.reposition(data: data,
                        unitWidth: unitWidth,
                        unitMargin: unitMargin,
                        containerSize: bounds.size)
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
            self.unitWidth = layer.unitWidth
            self.unitMargin = layer.unitMargin
            self.thickness = layer.thickness
            self.dashPattern = layer.dashPattern
            self.dashPhase = layer.dashPhase
            self.lineJoin = layer.lineJoin
        }
    }

    override open func additionalConfig(_ conf: (GraffeineLineLayer) -> ()) -> GraffeineLineLayer {
        conf(self)
        return self
    }
}
