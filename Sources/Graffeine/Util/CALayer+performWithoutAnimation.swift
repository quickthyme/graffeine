import UIKit

internal extension CALayer {

    func performWithoutAnimation(_ actions: () -> Void){
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actions()
        CATransaction.commit()
    }
}
