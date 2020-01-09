import UIKit

func normalized(_ val: CGFloat) -> CGFloat {
    return floor(val * 100) / 100
}

func normalized(_ rect: CGRect) -> CGRect {
    return CGRect(x: normalized(rect.origin.x),
                  y: normalized(rect.origin.y),
                  width: normalized(rect.size.width),
                  height: normalized(rect.size.height))
}
