import UIKit

extension GraffeineLayer {

    public struct Selection {
        public var fill:   Fill   = Fill()
        public var line:   Line   = Line()
        public var text:   Text   = Text()
        public var radial: Radial = Radial()

        public struct Fill {
            public var color: UIColor? = nil
        }

        public struct Line {
            public var color: UIColor? = nil
        }

        public struct Text {
            public var color: UIColor? = nil
        }

        public struct Radial {
            public var diameter: DimensionalUnit? = nil
        }
    }
}
