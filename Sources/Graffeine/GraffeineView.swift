import UIKit

open class GraffeineView: UIView {

    public typealias OnSelect = (GraffeineLayer.SelectionResult?) -> ()

    public typealias Region = GraffeineLayer.Region

    @IBInspectable public var configClass: String = ""

    public func pauseAllAnimations() {
        self.layer.removeAllAnimations()
    }

    public var onSelect: OnSelect? = nil

    public var layers: [GraffeineLayer] {
        get { return (self.layer.sublayers ?? Array<CALayer>()).compactMap { $0 as? GraffeineLayer } }
        set {
            let sublayers = (self.layer.sublayers?.compactMap { $0 as? GraffeineLayer }) ?? []
            let mainFrame = Region.calculateMainRegionFrame(layers: newValue,
                                                            bounds: self.bounds)
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
            for layer in newValue {
                layer.frame = Region.calculateRegionFrame(layer: layer,
                                                          precomputedMainRegionFrame: mainFrame)
                self.layer.addSublayer(layer)
            }
        }
    }

    internal var notificationCenter: NotificationCenterInterface {
        return NotificationCenter.default
    }

    public func layer(id: AnyHashable) -> GraffeineLayer? {
        return layers.first { $0.id == id }
    }

    override public func layoutSublayers(of layer: CALayer) {
        if layer === self.layer, let sublayers = layer.sublayers {
            let mainFrame = Region.calculateMainRegionFrame(layers: layers,
                                                            bounds: self.bounds)
            for sublayer in sublayers {
                if let sublayer = sublayer as? GraffeineLayer {
                    sublayer.frame = Region.calculateRegionFrame(layer: sublayer,
                                                                 precomputedMainRegionFrame: mainFrame)
                }
                sublayer.layoutSublayers()
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNotifications()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public convenience init(frame: CGRect, configClass: String) {
        self.init(frame: frame)
        self.configClass = configClass
        self.loadConfig()
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.loadConfig()
        self.setupNotifications()
    }

    deinit {
        self.tearDownNotifications()
    }

    private func loadConfig() {
        if let config = locateClass(named: configClass) as? GraffeineViewConfig.Type {
            let _ = config.init(self)
        }
    }

    private func locateClass(named: String) -> AnyClass? {
        let named = sanitize(named)
        let namespace = sanitize(
            (Bundle.main.infoDictionary?[String(kCFBundleExecutableKey)] as? String)
                ?? (Bundle(for: type(of: self)).infoDictionary?[String(kCFBundleExecutableKey)] as? String)
                ?? ""
        )

        guard (!named.isEmpty),
            let aClass = NSClassFromString("\(namespace).\(named)")
            else { return nil }
        return aClass
    }

    private func sanitize(_ str: String) -> String {
        return str.replacingOccurrences(of: "-", with: "_")
    }

    // MARK: - Selection and Touch
    private var touchBeganInside: Bool = false
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchBeganInside = touches.count == 1
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchBeganInside = false
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchBeganInside = false
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if (touchBeganInside && touches.count == 1),
            let touch = touches.first {
            handleUserSelection(touch.location(in: self))
        }
        touchBeganInside = false
    }

    internal func handleUserSelection(_ point: CGPoint) {
        let selectables = findSelectableLayers()
        let results = findSelected(point, selectables)
        self.onSelect?(results.first)
    }

    private func findSelectableLayers() -> [GraffeineLayer] {
        return layers.filter({ $0.selection.isEnabled })
    }

    private func findSelected(_ point: CGPoint, _ layers: [GraffeineLayer]) -> [GraffeineLayer.SelectionResult] {
        return layers.compactMap({ layer in

            let pointConvertedTo = self.layer.convert(point, to: layer)
            guard let selected = layer.findSelected(pointConvertedTo) else { return nil }
            let pointConvertedFrom = self.layer.convert(selected.point, from: layer)

            return GraffeineLayer.SelectionResult(
                point: normalized(pointConvertedFrom),
                data: selected.data,
                layer: selected.layer
            )
        })
    }
}
