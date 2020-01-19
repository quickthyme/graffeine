import UIKit

public protocol GraffeineLineDataAnimating: GraffeineDataAnimating {
    var delay: TimeInterval { get set }
    func animate(line: GraffeineLineLayer.Line, from: CGPath, to: CGPath)
}

extension GraffeineDataAnimators {

    public struct Line {
        private init() {}
    }
}
