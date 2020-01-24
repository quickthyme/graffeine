import UIKit

internal protocol LineSmoothingMethod {
    func pathBySmoothing(in path: UIBezierPath) -> UIBezierPath
}

internal extension LineSmoothingMethod {

    func extractPoints(from path: UIBezierPath) -> [CGPoint] {
        var retPoints: NSMutableArray = []
        path.cgPath.apply(info: &retPoints, function: { info, element in

            guard let resultPoints = info?.assumingMemoryBound(to: NSMutableArray.self) else {
                return
            }

            let points = element.pointee.points
            let type = element.pointee.type

            switch type {
            case .moveToPoint:
                resultPoints.pointee.add([NSNumber(value: Float(points[0].x)), NSNumber(value: Float(points[0].y))])

            case .addLineToPoint:
                resultPoints.pointee.add([NSNumber(value: Float(points[0].x)), NSNumber(value: Float(points[0].y))])

            case .addQuadCurveToPoint:
                resultPoints.pointee.add([NSNumber(value: Float(points[0].x)), NSNumber(value: Float(points[0].y))])
                resultPoints.pointee.add([NSNumber(value: Float(points[1].x)), NSNumber(value: Float(points[1].y))])

            case .addCurveToPoint:
                resultPoints.pointee.add([NSNumber(value: Float(points[0].x)), NSNumber(value: Float(points[0].y))])
                resultPoints.pointee.add([NSNumber(value: Float(points[1].x)), NSNumber(value: Float(points[1].y))])
                resultPoints.pointee.add([NSNumber(value: Float(points[2].x)), NSNumber(value: Float(points[2].y))])

            case .closeSubpath:
                break

            @unknown default:
                break
            }
        })

        return retPoints.compactMap {
            guard let nums = $0 as? [NSNumber] else { return nil }
            let x = CGFloat(nums.first?.floatValue ?? 0)
            let y = CGFloat(nums.last?.floatValue ?? 0)
            return CGPoint(x: x, y: y)
        }
    }
}
