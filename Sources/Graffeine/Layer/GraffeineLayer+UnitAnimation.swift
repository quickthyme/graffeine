import UIKit

extension GraffeineLayer {

    public struct UnitAnimation {

        private static let prefix = "GraffeineLayer.UnitAnimation."
        private var prefix: String { return UnitAnimation.prefix }

        public init() {}

        private var animations: [String: CAAnimation] = [:]

        public var animationKeys: [String] {
            return animations.map { $0.key }
        }

        public mutating func add(_ key: String, _ animation: CAAnimation) {
            self.animations[prefix + key] = animation
        }

        public mutating func remove(_ key: String) {
            self.animations.removeValue(forKey: prefix + key)
        }

        public mutating func removeAll() {
            self.animations.removeAll()
        }

        public func apply(to target: CALayer) {
            removeUnwantedAnimations(from: target)
            addWantedAnimations(to: target)
        }

        private func removeUnwantedAnimations(from target: CALayer) {
            let wantedKeys = self.animationKeys
            let appliedKeys = (target.animationKeys() ?? [])
                .filter({ $0.starts(with: prefix) })

            for key in appliedKeys {
                if !wantedKeys.contains(key) {
                    target.removeAnimation(forKey: key)
                }
            }
        }

        private func addWantedAnimations(to target: CALayer) {
            for (key, animation) in animations {
                target.add(animation, forKey: key)
            }
        }
    }
}
