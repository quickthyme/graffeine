import UIKit

internal extension CALayer {
    func performWithoutAnimation(_ actions: () -> Void){
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actions()
        CATransaction.commit()
    }
}

internal let OneDegreeInRadians = (CGFloat.pi / 180)

internal let DegreesToRadians: (CGFloat) -> (CGFloat) = {
    return $0 * OneDegreeInRadians
}
