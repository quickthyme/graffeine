import UIKit

extension GraffeineLayer {

    public struct UnitAnimation {
        private static let prefixPerpetual: String = "GraffeineLayer.UnitAnimation.Perpetual."
        public init() {}

        public var perpetual: PerpetualContainer = PerpetualContainer(prefix: prefixPerpetual)
        public var data: DataContainer = DataContainer()
    }
}

extension GraffeineLayer.UnitAnimation {

    public struct PerpetualContainer {

        internal var prefix: String

        public init(prefix: String) {
            self.prefix = prefix
        }

        private var animations: [String: CAAnimation] = [:]

        public var animationKeys: [String] {
            let prefixCount = prefix.count
            return animations.map { String($0.key.dropFirst(prefixCount)) }
        }

        internal var prefixedAnimationKeys: [String] {
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
            let wantedKeys = self.prefixedAnimationKeys
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

extension GraffeineLayer.UnitAnimation {

    public struct DataContainer {

        public init() {
        }

        private var animators: [GraffeineData.AnimationSemantic: GraffeineDataAnimating] = [:]

        public var semantics: [GraffeineData.AnimationSemantic] {
            return animators.map { $0.key }
        }

        public mutating func add(animator: GraffeineDataAnimating, for semantic: GraffeineData.AnimationSemantic) {
            guard (semantic != .notAnimated) else { return }
            self.animators[semantic] = animator
        }

        public mutating func remove(for semantic: GraffeineData.AnimationSemantic) {
            self.animators.removeValue(forKey: semantic)
        }

        public mutating func removeAll() {
            self.animators.removeAll()
        }

        public func get(for semantic: GraffeineData.AnimationSemantic) -> GraffeineDataAnimating? {
            return animators[semantic]
        }
    }
}
