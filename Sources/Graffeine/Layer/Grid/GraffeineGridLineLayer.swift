import UIKit

open class GraffeineGridLineLayer: GraffeineLayer {

    public typealias Alignment = GraffeineAlignment.Horizontal
    public typealias Padding = GraffeinePadding

    public var alignment: Alignment = .center
    public var length: DimensionalUnit = .percentage(1.0)
    public var positioner: Positioner = .default

    override open func generateSublayer() -> CALayer {
        return GridLine()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }

        for (index, line) in sublayers.enumerated() {
            guard let line = line as? GridLine else { continue }
            line.alignment = alignment
            line.length = length
            line.flipXY = flipXY

            unitLine.apply(to: line, index: index)
            unitShadow.apply(to: line)
            unitAnimation.apply(to: line)

            let txData = GraffeineData(transposed: data)

            positioner.get().reposition(line: line,
                                        for: index,
                                        in: txData,
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
            self.alignment = layer.alignment
            self.length = layer.length
            self.positioner = layer.positioner
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineGridLineLayer) -> ()) -> GraffeineGridLineLayer {
        conf(self)
        return self
    }
}
