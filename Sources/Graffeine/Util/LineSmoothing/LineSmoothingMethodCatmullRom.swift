// //
// Centripetal Catmull-Rom Spline
// https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline
// //

import UIKit

internal class LineSmoothingMethodCatmullRom: LineSmoothingMethod {

    internal var granularity: Int = 0

    internal init(granularity: Int) {
        self.granularity = granularity
    }

    internal func pathBySmoothing(in path: UIBezierPath) -> UIBezierPath {
        var points = extractPoints(from: path)
        let smoothPath = path.copy() as! UIBezierPath

        guard (points.count > 3) else { return smoothPath }

        points.insert(points.first!, at: 0)
        points.append(points.last!)
        smoothPath.removeAllPoints()
        smoothPath.move(to: points[0])

        let epoints = Array<Int>(1..<points.count - 2)

        for index in epoints {
            let p0 = points[index - 1]
            let p1 = points[index]
            let p2 = points[index + 1]
            let p3 = points[index + 2]

            let igrain = Array(1..<granularity)
            for i in igrain {
                let i = Int(i)
                let t: CGFloat   = CGFloat(i) * (CGFloat(1.0) / CGFloat(granularity))
                let tt: CGFloat  = t  * t
                let ttt: CGFloat = tt * t
                let intermediatePoint = CGPoint(
                    x: 0.5 * (2 * p1.x + (p2.x - p0.x)
                        * t + (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x)
                        * tt + (3 * p1.x - p0.x - 3 * p2.x + p3.x)
                        * ttt),

                    y: 0.5 * (2 * p1.y + (p2.y - p0.y)
                        * t + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y)
                        * tt + (3 * p1.y - p0.y - 3 * p2.y + p3.y)
                        * ttt)
                )
                smoothPath.addLine(to: intermediatePoint)
            }
            smoothPath.addLine(to: p2)
        }
        smoothPath.addLine(to: points.last!)
        return smoothPath
    }
}
