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

        let hPos = getHPosition(line.alignment, translatedContainerSize.width)
        let width: CGFloat = line.length.resolved(within: translatedContainerSize.width)
        let yPos: CGFloat = translatedContainerSize.height * valPercentInverted
        let intendedPoint = CGPoint(x: hPos.x, y: yPos)
        let thicknessOffsetPoint = thicknessOffset(line, intendedPoint, translatedContainerSize)
        let newPosition: CGPoint = translatedPosition(line, thicknessOffsetPoint)

        line.performWithoutAnimation {
            line.anchorPoint = translatedPosition(line, CGPoint(x: hPos.anchorX, y: 0.5))
            line.frame.size = translatedSize(line, CGSize(width: width, height: 0.0) )
            line.path = line.constructPath().cgPath
            line.position = newPosition
        }
    }

    private func getHPosition(_ alignment: GraffeineGridLineLayer.Alignment,
                              _ boundWidth: CGFloat) -> (x: CGFloat, anchorX: CGFloat) {

        switch alignment {
        case .left:     return (x: CGFloat(0              ), anchorX: CGFloat(0.0))
        case .center:   return (x: CGFloat(boundWidth / 2 ), anchorX: CGFloat(0.5))
        case .right:    return (x: CGFloat(boundWidth     ), anchorX: CGFloat(1.0))
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
            return (line.flipXY)
                ? CGPoint(x: 1.0, y: 0.0)
                : CGPoint(x: 0.0, y: 0.0)

        case (yPosInt == containerHeightInt):
            return (line.flipXY)
                ? CGPoint(x: 0.0, y: 0.0)
                : CGPoint(x: 0.0, y: 1.0)

        default:
            return (line.flipXY)
                ? CGPoint(x: 0.5, y: 0.0)
                : CGPoint(x: 0.0, y: 0.5)
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
