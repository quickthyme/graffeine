import UIKit

public struct GraffeineRadialGridLayerDefaultPositioner: GraffeineRadialGridLayerPositioning {

    public func reposition(line: GraffeineRadialGridLayer.GridLine,
                           for index: Int,
                           in data: GraffeineData,
                           containerSize: CGSize) {

        guard let value = data.values.hi[index] else {
            line.performWithoutAnimation {
                line.path = nil
            }
            return
        }

        let centerPoint = CGPoint(x: containerSize.width / 2, y: containerSize.height / 2)

        let maxVal = data.valueMaxOrHighestHi
        let valPercent: CGFloat = CGFloat(value / maxVal)
        let maxRadius: CGFloat = line.maxRadius
        let radius: CGFloat = maxRadius * valPercent

        let newPath = line.constructPath(radius: radius,
                                         centerPoint: centerPoint)

        line.performWithoutAnimation {
            line.path = newPath.cgPath
        }
    }

    private func thicknessOffset(_ line: GraffeineGridLineLayer.GridLine,
                                 _ point: CGPoint,
                                 _ containerSize: CGSize) -> CGPoint {
        let yPosInt = Int( ceil(point.y) )
        let containerHeightInt = Int( ceil(containerSize.height) )
        let halfWidth = line.lineWidth * 0.5
        switch true {
        case (yPosInt == 0):
            return CGPoint(x: point.x, y: point.y + halfWidth)
        case (yPosInt == containerHeightInt):
            return CGPoint(x: point.x, y: point.y - halfWidth)
        default:
            return point
        }
    }
}
