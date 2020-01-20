import UIKit

extension GraffeineBarLayer {

    public enum RoundedEnds {
        case none
        case hi(CGFloat), lo(CGFloat), both(CGFloat)

        public func getRadius() -> CGFloat {
            switch self {
            case let .hi(r):   return r
            case let .lo(r):   return r
            case let .both(r): return r
            default:           return 0
            }
        }

        public func cornerRadii() -> CGSize {
            let r = self.getRadius()
            return CGSize(width: r, height: r)
        }

        public func translatedRoundingCorners(_ flipXY: Bool) -> UIRectCorner {
            switch (self) {
            case .hi:   return (flipXY) ? [.topRight, .bottomRight] : [.topLeft, .topRight]
            case .lo:   return (flipXY) ? [.topLeft,  .bottomLeft]  : [.bottomLeft, .bottomRight]
            case .both: return .allCorners
            default:    return []
            }
        }
    }
}
