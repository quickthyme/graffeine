import UIKit

open class GraffeineGridLineLayer: GraffeineLayer {

    override open func generateSublayer() -> CALayer {
        return GridLine()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }

        for (index, line) in sublayers.enumerated() {
            guard let line = line as? GridLine else { continue }
            line.flipXY = flipXY

            unitLine.apply(to: line, index: index)
            unitShadow.apply(to: line)

            line.reposition(for: index,
                            in: data,
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

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
//        if let layer = layer as? Self {
//        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineGridLineLayer) -> ()) -> GraffeineGridLineLayer {
        conf(self)
        return self
    }
}
