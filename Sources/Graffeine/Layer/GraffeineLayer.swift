import UIKit

open class GraffeineLayer: CALayer {

    open var region: Region = .main

    open var insets: UIEdgeInsets = .zero

    open var id: AnyHashable = Int(0)

    public var unitColumn: UnitColumn = UnitColumn()
    public var unitFill:   UnitFill   = UnitFill()
    public var unitLine:   UnitLine   = UnitLine()
    public var unitShadow: UnitShadow = UnitShadow()

    public var selection: Selection = Selection()

    open var flipXY: Bool = false {
        didSet { self.addOrRemoveSublayers() }
    }

    private var _data: GraffeineData = GraffeineData()

    public var data: GraffeineData {
        get { return _data }
        set { setData(newValue, animator: nil) }
    }

    open func setData(_ data: GraffeineData, animator: GraffeineDataAnimating?) {
        _data = data
        addOrRemoveSublayers()
        if let animator = animator {
            repositionSublayers(animator: animator)
        } else {
            setNeedsLayout()
        }
    }

    override public init() {
        super.init()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? GraffeineLayer {
            self.region = layer.region
            self.insets = layer.insets
            self.id = layer.id
            self.flipXY = layer.flipXY
            self.data = layer.data
            self.unitColumn = layer.unitColumn
            self.unitFill = layer.unitFill
            self.unitLine = layer.unitLine
            self.unitShadow = layer.unitShadow
            self.selection = layer.selection
        }
    }

    override open func layoutSublayers() {
        super.layoutSublayers()
        repositionSublayers()
    }

    open var expectedNumberOfSublayers: Int {
        return self.data.values.count
    }

    open func generateSublayer() -> CALayer {
        return CALayer()
    }

    open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        /* */
    }

    open func addOrRemoveSublayers() {
        let targetCount = expectedNumberOfSublayers
        let currentCount = (sublayers?.count ?? 0)
        if (currentCount < targetCount) {
            addSublayersToEnd(targetCount - currentCount)
        } else if (currentCount > targetCount) {
            removeSublayersFromEnd(currentCount - targetCount)
        }
    }

    open func removeSublayersFromEnd(_ n: Int) {
        guard (self.sublayers != nil) else { return }
        let targetCount = max(sublayers!.count - n, 0)
        while (sublayers!.count > targetCount) {
            sublayers!.last!.removeFromSuperlayer()
        }
    }

    open func addSublayersToEnd(_ n: Int) {
        let targetCount = (sublayers?.count ?? 0) + n
        while ((sublayers?.count ?? 0) < targetCount) {
            addSublayer( generateSublayer() )
        }
    }

    @discardableResult
    open func apply(_ conf: (GraffeineLayer) -> ()) -> GraffeineLayer {
        conf(self)
        return self
    }
}
