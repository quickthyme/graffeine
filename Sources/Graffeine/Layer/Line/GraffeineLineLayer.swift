import UIKit

open class GraffeineLineLayer: GraffeineLayer {

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative
    public var unitMargin: CGFloat = 4.0

    public var thickness: CGFloat = 0.5
    public var dashPattern: [NSNumber]? = nil
    public var dashPhase: CGFloat = 0
    public var lineJoin: CAShapeLayerLineJoin = .bevel
    public var lineCap: CAShapeLayerLineCap = .butt

    override open var expectedNumberOfSublayers: Int {
        return 1
    }

    override open func generateSublayer() -> CALayer {
        return Line()
    }

    override open func repositionSublayers(animated: Bool,
                                           duration: TimeInterval,
                                           timing: CAMediaTimingFunctionName) {
        guard let line = self.sublayers?.first(where: { $0 is Line }) as? Line
            else { return }
        line.strokeColor = safeIndexedColor(0)
        line.lineWidth = thickness
        line.lineDashPattern = dashPattern
        line.lineDashPhase = dashPhase
        line.lineJoin = lineJoin
        line.lineCap = lineCap
        line.reposition(data: data,
                        unitWidth: unitWidth,
                        unitMargin: unitMargin,
                        containerSize: bounds.size,
                        animated: animated,
                        duration: duration,
                        timing: timing)
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
            self.lineCap = layer.lineCap
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineLineLayer) -> ()) -> GraffeineLineLayer {
        conf(self)
        return self
    }
}
