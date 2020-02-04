import UIKit

public struct GraffeineGridLineLayerDefaultPositioner: GraffeineGridLineLayerPositioning {

    public func reposition(line: GraffeineGridLineLayer.GridLine,
                           for index: Int,
                           in data: GraffeineData,
                           containerSize: CGSize) {

        guard let value = data.values.hi[index] else {
            line.performWithoutAnimation {
                line.frame.size.width = 1.0
                line.frame.size.height = 0.0
                line.position = CGPoint(x: 0, y: 0)
            }
            return
        }

        let translatedContainerSize = translatedSize(line, containerSize)
        let maxVal = data.valueMaxOrHighestHi

        let valPercentInverted: CGFloat = (value <= maxVal)
            ? 1.0 - CGFloat(value / maxVal)
            : 0.0

        let yPos: CGFloat = translatedContainerSize.height * valPercentInverted

        line.performWithoutAnimation {
            line.anchorPoint = translatedAnchor(line, yPos, translatedContainerSize)
            line.frame.size = translatedSize(line, CGSize(width: translatedContainerSize.width, height: 0.0) )
            line.path = generatePath(for: line).cgPath
            line.position = translatedPosition(
                line,
                thicknessOffset(line,
                                CGPoint(x: 0, y: translatedContainerSize.height * valPercentInverted),
                                translatedContainerSize)
            )
        }
    }

    private func translatedSize(_ line: GraffeineGridLineLayer.GridLine,
                                _ size: CGSize) -> CGSize {
        return (line.flipXY)
            ? CGSize(width: size.height, height: size.width)
            : size
    }

    private func translatedPosition(_ line: GraffeineGridLineLayer.GridLine,
                                    _ point: CGPoint) -> CGPoint {
        return (line.flipXY)
            ? CGPoint(x: point.y, y: point.x)
            : point
    }

    private func translatedAnchor(_ line: GraffeineGridLineLayer.GridLine,
                                  _ yPos: CGFloat,
                                  _ containerSize: CGSize) -> CGPoint {
        let yPosInt = Int( ceil(yPos) )
        let containerHeightInt = Int( ceil(containerSize.height) )
        switch true {
        case (yPosInt == 0):
            return (line.flipXY) ? CGPoint(x: 1.0, y: 0.0) : CGPoint(x: 0.0, y: 0.0)
        case (yPosInt == containerHeightInt):
            return (line.flipXY) ? CGPoint(x: 0.0, y: 0.0) : CGPoint(x: 0.0, y: 1.0)
        default:
            return (line.flipXY) ? CGPoint(x: 0.5, y: 0.0) : CGPoint(x: 0.0, y: 0.5)
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

    func generatePath(for line: GraffeineGridLineLayer.GridLine) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: line.bounds.size.width, y: line.bounds.size.height))
        return path
    }
}
