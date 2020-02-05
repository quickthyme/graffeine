import UIKit

public struct GraffeinePadding: Equatable {

    public var horizontal: CGFloat = 0

    public var vertical: CGFloat = 0

    public init() {}

    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public static var zero: GraffeinePadding {
        return GraffeinePadding()
    }
}
