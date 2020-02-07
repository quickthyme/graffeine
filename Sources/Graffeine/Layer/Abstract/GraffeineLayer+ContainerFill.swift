import UIKit

extension GraffeineLayer {

    public struct ContainerFill {

        public var color: UIColor? = nil

        public init(color: UIColor? = nil) {
            self.color = color
        }

        public func apply(to target: GraffeineLayer) {
            target.backgroundColor = color?.cgColor
        }
    }
}
