import UIKit

open class GraffeineLineLayer: GraffeineLayer {

    public enum Smoothing {
        case none
        case catmullRom(Int)
        case custom(LineSmoothingMethod)
    }

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative
    public var smoothing: Smoothing = .none
    public var positioner: Positioner = .column

    override open var expectedNumberOfSublayers: Int {
        return 2
    }

    override open func generateSublayer() -> CALayer {
        return Line()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard
            let fill = sublayers?.first as? Line,
            let line = sublayers?.last as? Line
            else { return }

        line.unitColumn = unitColumn
        fill.unitColumn = unitColumn
        unitFill.apply(to: fill)
        unitLine.apply(to: line)
        unitShadow.apply(to: line)
        unitAnimation.apply(to: line)
        if let selectedIndex = data.selected.index {
            applySelectionState(line, index: selectedIndex)
        }

        positioner.get().reposition(line: line,
                                    fill: fill,
                                    data: data,
                                    containerSize: bounds.size,
                                    smoothing: smoothing,
                                    animator: animator as? GraffeineLineDataAnimating)
    }

    override public init() {
        super.init()
        self.unitColumn.reducedByOne = true
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
            self.smoothing = layer.smoothing
            self.positioner = layer.positioner
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineLineLayer) -> ()) -> GraffeineLineLayer {
        conf(self)
        return self
    }
}
