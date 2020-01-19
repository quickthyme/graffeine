import UIKit

public protocol GraffeineLineDataAnimating: GraffeineDataAnimating {
    func animate(line: GraffeineLineLayer.Line, from: CGPath, to: CGPath)
}

extension GraffeineDataAnimators {

    public struct Line {
        private init() {}
    }
}
