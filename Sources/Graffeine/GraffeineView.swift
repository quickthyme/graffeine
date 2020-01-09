import UIKit

open class GraffeineView: UIView {

    @IBInspectable public var configClass: String = ""

    public var layers: [GraffeineLayer] {
        get { return (self.layer.sublayers ?? Array<CALayer>()).compactMap { $0 as? GraffeineLayer } }
        set {
            let sublayers = (self.layer.sublayers?.compactMap { $0 as? GraffeineLayer }) ?? []
            let mainFrame = calculateMainRegionFrame(newValue)

            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
            for layer in newValue {
                layer.frame = calculateRegionFrame(layer, precomputedMainRegionFrame: mainFrame)
                self.layer.addSublayer(layer)
            }
        }
    }

    public func layer(id: AnyHashable) -> GraffeineLayer? {
        return layers.first { $0.id == id }
    }

    override public func layoutSublayers(of layer: CALayer) {
        if layer === self.layer, let sublayers = layer.sublayers {
            let mainFrame = calculateMainRegionFrame(layers)
            for sublayer in sublayers {
                if let sublayer = sublayer as? GraffeineLayer {
                    sublayer.frame = calculateRegionFrame(sublayer, precomputedMainRegionFrame: mainFrame)
                }
                sublayer.layoutSublayers()
            }
        }
    }

    public func calculateMainRegionFrame(_ layers: [GraffeineLayer]) -> CGRect {
        let bounds = self.bounds

        return layers.reduce(bounds) { result, next in
            var output = result
            switch next.region {

            case .topGutter:
                let delta = next.frame.size.height - output.origin.y
                if (delta > 0) {
                    output.origin.y += delta
                    output.size.height -= delta
                }

            case .rightGutter:
                let gutterX = output.origin.x + output.size.width
                let gutterWidth = (bounds.size.width - gutterX)
                let delta = next.frame.size.width - gutterWidth
                if (delta > 0) {
                    output.size.width -= delta
                }

            case .bottomGutter:
                let gutterY = output.origin.y + output.size.height
                let gutterHeight = (bounds.size.height - gutterY)
                let delta = next.frame.size.height - gutterHeight
                if (delta > 0) {
                    output.size.height -= delta
                }

            case .leftGutter:
                let delta = next.frame.size.width - output.origin.x
                if (delta > 0) {
                    output.origin.x += delta
                    output.size.width -= delta
                }

            case .main:
                break
            }
            return output
        }
    }

    public func calculateRegionFrame(_ layer: GraffeineLayer, precomputedMainRegionFrame mainFrame: CGRect) -> CGRect {
        let layerFrame = layer.frame

        switch layer.region {

        case .topGutter:
            return CGRect(x: mainFrame.origin.x,
                          y: 0.0,
                          width: mainFrame.size.width,
                          height: layerFrame.height)

        case .rightGutter:
            return CGRect(x: mainFrame.origin.x + mainFrame.size.width,
                          y: mainFrame.origin.y,
                          width: layerFrame.size.width,
                          height: mainFrame.size.height)

        case .bottomGutter:
            return CGRect(x: mainFrame.origin.x,
                          y: mainFrame.origin.y + mainFrame.size.height,
                          width: mainFrame.size.width,
                          height: layerFrame.size.height)

        case .leftGutter:
            return CGRect(x: 0.0,
                          y: mainFrame.origin.y,
                          width: layerFrame.size.width,
                          height: mainFrame.size.height)

        case .main:
            return mainFrame
        }
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        loadConfig()
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
}
