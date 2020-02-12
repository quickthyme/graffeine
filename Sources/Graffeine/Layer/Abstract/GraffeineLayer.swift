import UIKit

open class GraffeineLayer: CALayer {

    public typealias Applicator = (GraffeineLayer) -> ()

    public var id: AnyHashable = Int(0)
    public var region: Region = .main
    public var insets: UIEdgeInsets = .zero
    public var maskInsets: UIEdgeInsets = .zero
    public var fill: ContainerFill = ContainerFill()
    public var unitColumn: UnitColumn = UnitColumn()
    public var unitFill:   UnitFill   = UnitFill()
    public var unitLine:   UnitLine   = UnitLine()
    public var unitShadow: UnitShadow = UnitShadow()
    public var unitAnimation: UnitAnimation = UnitAnimation()
    public var selection: Selection = Selection()

    public var flipXY: Bool = false {
        didSet { self.addOrRemoveSublayers() }
    }

    private var _data: GraffeineData = GraffeineData()

    public var data: GraffeineData {
        get { return _data }
        set { setData(newValue, semantic: .notAnimated) }
    }

    open func setData(_ data: GraffeineData, semantic: GraffeineData.AnimationSemantic = .notAnimated) {
        _data = data
        addOrRemoveSublayers()
        if let animator = unitAnimation.data.get(for: semantic) {
            repositionSublayers(animator: animator)
        } else {
            setNeedsLayout()
        }
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentsScale = UIScreen.main.scale
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? GraffeineLayer {
            self.region = layer.region
            self.insets = layer.insets
            self.maskInsets = layer.maskInsets
            self.id = layer.id
            self.flipXY = layer.flipXY
            self.data = layer.data
            self.fill = layer.fill
            self.unitColumn = layer.unitColumn
            self.unitFill = layer.unitFill
            self.unitLine = layer.unitLine
            self.unitShadow = layer.unitShadow
            self.unitAnimation = layer.unitAnimation
            self.selection = layer.selection
        }
    }

    override open func layoutSublayers() {
        super.layoutSublayers()
        fill.apply(to: self)
        applyClippingMaskIfEnabled()
        repositionSublayers()
    }

    open var expectedNumberOfSublayers: Int {
        return self.data.values.hi.count
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
        while ((sublayers?.count ?? 0) > targetCount) {
            sublayers?.last?.removeFromSuperlayer()
        }
    }

    open func addSublayersToEnd(_ n: Int) {
        let targetCount = (sublayers?.count ?? 0) + n
        while ((sublayers?.count ?? 0) < targetCount) {
            addSublayer( generateSublayer() )
        }
    }

    @discardableResult
    open func apply(_ applicator: Applicator) -> GraffeineLayer {
        applicator(self)
        return self
    }

    private func applyClippingMaskIfEnabled() {
        guard (maskInsets != .zero) else { return }
        let maskFrame = CGRect(x: 0 + maskInsets.left,
                               y: 0 + maskInsets.top,
                               width: bounds.size.width - maskInsets.right - maskInsets.left,
                               height: bounds.size.height - maskInsets.top - maskInsets.bottom)

        let mask = CAShapeLayer()
        mask.contentsScale = self.contentsScale
        mask.path = UIBezierPath(rect: maskFrame).cgPath
        mask.fillColor = UIColor.black.cgColor
        self.mask = mask
    }
}
