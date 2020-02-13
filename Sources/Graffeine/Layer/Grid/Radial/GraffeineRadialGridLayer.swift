import UIKit

open class GraffeineRadialGridLayer: GraffeineLayer {

    public var maxDiameter: GraffeineLayer.DimensionalUnit = .percentage(1.0)
    public var positioner: Positioner = .default

    override open func generateSublayer() -> CALayer {
        return GridLine()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }

        for (index, line) in sublayers.enumerated() {
            guard let line = line as? GridLine else { continue }

            line.maxRadius = resolveRadius(diameter: maxDiameter, bounds: bounds)
            unitLine.apply(to: line, index: index)
            unitFill.apply(to: line, index: index)
            unitShadow.apply(to: line)
            unitAnimation.perpetual.apply(to: line)

            positioner.get().reposition(line: line,
                                        for: index,
                                        in: data,
                                        containerSize: bounds.size)
        }
    }

    override public init() {
        super.init()
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
            self.maxDiameter = layer.maxDiameter
            self.positioner = layer.positioner
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineRadialGridLayer) -> ()) -> GraffeineRadialGridLayer {
        conf(self)
        return self
    }
}
