import UIKit

internal extension UIBezierPath {

    func pathBySmoothing(method: LineSmoothingMethod) -> UIBezierPath {
        return UIBezierPath.pathBySmoothing(in: self, method: method)
    }

    static func pathBySmoothing(in path: UIBezierPath, method: LineSmoothingMethod) -> UIBezierPath {
        return method.pathBySmoothing(in: path)
    }
}
