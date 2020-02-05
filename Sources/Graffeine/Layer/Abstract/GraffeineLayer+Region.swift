import UIKit

extension GraffeineLayer {

    public enum Region {
        case main, topGutter, rightGutter, bottomGutter, leftGutter


        public static func calculateMainRegionFrame(layers: [GraffeineLayer], bounds: CGRect) -> CGRect {

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

        public static func calculateRegionFrame(layer: GraffeineLayer, precomputedMainRegionFrame mainFrame: CGRect) -> CGRect {
            let layerFrame = layer.frame
            let insets = layer.insets
            let insetSize = CGSize(width: insets.left + insets.right,
                                   height: insets.top + insets.bottom)

            switch layer.region {

            case .topGutter:
                return CGRect(x: mainFrame.origin.x + insets.left,
                              y: 0.0 + insets.top,
                              width: mainFrame.size.width - insetSize.width,
                              height: layerFrame.height - insetSize.height)

            case .rightGutter:
                return CGRect(x: mainFrame.origin.x + mainFrame.size.width + insets.left,
                              y: mainFrame.origin.y + insets.top,
                              width: layerFrame.size.width - insetSize.width,
                              height: mainFrame.size.height - insetSize.height)

            case .bottomGutter:
                return CGRect(x: mainFrame.origin.x + insets.left,
                              y: mainFrame.origin.y + mainFrame.size.height + insets.top,
                              width: mainFrame.size.width - insetSize.width,
                              height: layerFrame.size.height - insetSize.height)

            case .leftGutter:
                return CGRect(x: 0.0 + insets.left,
                              y: mainFrame.origin.y + insets.top,
                              width: layerFrame.size.width - insetSize.width,
                              height: mainFrame.size.height - insetSize.height)

            case .main:
                return CGRect(x: mainFrame.origin.x + insets.left,
                              y: mainFrame.origin.y + insets.top,
                              width: mainFrame.size.width - insetSize.width,
                              height: mainFrame.size.height - insetSize.height)
            }
        }

    }
}
