import UIKit

public struct GraffeineAlignment: Equatable {

    public enum Horizontal: Equatable {
        case left, center, right
    }

    public enum Vertical: Equatable {
        case top, center, bottom
    }

    public var horizontal: Horizontal = .center

    public var vertical: Vertical = .center

    public init() {}

    public init(horizontal: Horizontal, vertical: Vertical) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}
