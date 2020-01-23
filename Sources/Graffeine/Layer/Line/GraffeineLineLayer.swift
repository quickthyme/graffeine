import UIKit

open class GraffeineLineLayer: GraffeineLayer {

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative
    public var unitMargin: CGFloat = 4.0

    override open var expectedNumberOfSublayers: Int {
        return 1
    }

    override open func generateSublayer() -> CALayer {
        return Line()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let line = self.sublayers?.first(where: { $0 is Line }) as? Line
            else { return }

        unitFill.apply(to: line)
        unitLine.apply(to: line)
        unitShadow.apply(to: line)

        line.reposition(data: data,
                        unitWidth: unitWidth,
                        unitMargin: unitMargin,
                        containerSize: bounds.size,
                        animator: animator as? GraffeineLineDataAnimating)
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
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineLineLayer) -> ()) -> GraffeineLineLayer {
        conf(self)
        return self
    }
}
