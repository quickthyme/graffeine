import UIKit

extension GraffeineLayer {

    public struct ColorIndex {
        private init() {}

        public static func retrieve(at index: Int, cyclingThrough colors: [UIColor]) -> CGColor? {
            return (colors.isEmpty) ? nil : colors[(index % colors.count)].cgColor
        }
    }
}
