import UIKit

extension GraffeineLayer {

    public struct LabelAlignment {
        private init() {}

        internal static let horizontalLabelTextAlignmentMap: [HorizontalMode: CATextLayerAlignmentMode] = [
            .left: .left,
            .right: .right,
            .center: .center
        ]

        public enum HorizontalMode {
            case left, right, center, centerLeftRight

            public func textAlignment(for index: Int, in labels: [String?]) -> CATextLayerAlignmentMode {
                return LabelAlignment.horizontalLabelTextAlignmentMap[self]
                    ?? centerLeftRightTextAlignment(for: index, in: labels)
            }

            internal func centerLeftRightTextAlignment(for index: Int, in labels: [String?]) -> CATextLayerAlignmentMode {
                switch true {
                case (index == 0):
                    return .left
                case (index == labels.count - 1):
                    return .right
                default:
                    return .center
                }
            }
        }

        public enum VerticalMode {
            case top, bottom, center, centerTopBottom

            public func calculateYOffset(for index: Int,
                                         in labels: [String?],
                                         fontSize: CGFloat,
                                         padding: CGFloat,
                                         within height: CGFloat) -> CGFloat {
                switch self {

                case .top:
                    return 0.0 + padding

                case .bottom:
                    return (height - fontSize - 4.0) - padding

                case .center:
                    return (height - fontSize - 1.0) * 0.5

                case .centerTopBottom:
                    return centerTopBottomVerticalAlignment(for: index,
                                                            in: labels,
                                                            fontSize: fontSize,
                                                            padding: padding,
                                                            within: height)
                }
            }

            internal func centerTopBottomVerticalAlignment(for index: Int,
                                                           in labels: [String?],
                                                           fontSize: CGFloat,
                                                           padding: CGFloat,
                                                           within height: CGFloat) -> CGFloat {
                switch true {
                case (index == 0):
                    return VerticalMode.top.calculateYOffset(for: index,
                                                             in: labels,
                                                             fontSize: fontSize,
                                                             padding: padding,
                                                             within: height)

                case (index == labels.count - 1):
                    return VerticalMode.bottom.calculateYOffset(for: index,
                                                                in: labels,
                                                                fontSize: fontSize,
                                                                padding: padding,
                                                                within: height)

                default:
                    return VerticalMode.center.calculateYOffset(for: index,
                                                                in: labels,
                                                                fontSize: fontSize,
                                                                padding: padding,
                                                                within: height)
                }
            }
        }
    }
}
