import UIKit

internal func normalized<T: FloatingPoint>(_ val: T) -> T {
    return floor(val * 100) / 100
}

internal func normalized(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: normalized(point.x),
                   y: normalized(point.y))
}

internal func normalized(_ rect: CGRect) -> CGRect {
    return CGRect(x: normalized(rect.origin.x),
                  y: normalized(rect.origin.y),
                  width: normalized(rect.size.width),
                  height: normalized(rect.size.height))
}
