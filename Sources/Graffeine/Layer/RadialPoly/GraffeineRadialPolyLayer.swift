import UIKit

open class GraffeineRadialPolyLayer: GraffeineLayer {

    public var rotation: UInt = 0
    public var maxDiameter: GraffeineLayer.DimensionalUnit = .percentage(1.0)
    public var positioner: Positioner = .default

    override open var expectedNumberOfSublayers: Int {
        return 1
    }

    override open func generateSublayer() -> CALayer {
        return Polygon()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let poly = sublayers.first as! Polygon
        let centerPoint = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)

        poly.rotation = rotation
        poly.maxRadius = resolveRadius(diameter: maxDiameter, bounds: bounds)
        unitFill.apply(to: poly)
        unitLine.apply(to: poly)
        unitShadow.apply(to: poly)
        unitAnimation.perpetual.apply(to: poly)

        positioner.get().reposition(poly: poly,
                                    data: data,
                                    centerPoint: centerPoint,
                                    animator: animator as? GraffeineRadialPolyDataAnimating)
    }

    override public init() {
        super.init()
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
            self.rotation = layer.rotation
            self.maxDiameter = layer.maxDiameter
            self.positioner = layer.positioner
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineRadialPolyLayer) -> ()) -> GraffeineRadialPolyLayer {
        conf(self)
        return self
    }
}
