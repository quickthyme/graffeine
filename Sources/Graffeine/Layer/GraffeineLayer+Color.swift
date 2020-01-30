import UIKit

extension GraffeineLayer {

    public struct Color {
        private init() {}

        public static func retrieve(at index: Int, cyclingThrough colors: [UIColor]) -> CGColor? {
            return (colors.isEmpty) ? nil : colors[(index % colors.count)].cgColor
        }
    }
}

public extension UIColor {

    func modifiedByAdding(alpha: CGFloat? = nil, brightness: CGFloat? = nil) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        if (self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)) {
            let newAlpha = (alpha != nil)
                ? max(min((a + alpha!), 1.0), 0)
                : a
            let newBrightness = (brightness != nil)
                ? max(min((b + brightness!), 1.0), 0)
                : b

            return UIColor(hue: h,
                           saturation: s,
                           brightness: newBrightness,
                           alpha: newAlpha)
        }
        return self
    }
}

public extension CGColor {

    func modifiedByAdding(alpha: CGFloat? = nil, brightness: CGFloat? = nil) -> CGColor {
        return UIColor(cgColor: self)
            .modifiedByAdding(alpha: alpha, brightness: brightness)
            .cgColor
    }
}
