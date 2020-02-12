import XCTest
@testable import Graffeine

class UnitAnimationTests: XCTestCase {

    var layer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 20, height: 20)).cgPath
        return layer
    }()

    var subject: GraffeineLayer.UnitAnimation!

    override func setUp() {
        subject = GraffeineLayer.UnitAnimation()
    }

    func test_adding_and_removing_perpetual_animations_key_retrieve() {
        subject.perpetual.add("banana", CAAnimation())
        XCTAssertEqual(subject.perpetual.animationKeys, ["banana"])
        XCTAssertEqual(subject.perpetual.prefixedAnimationKeys, ["GraffeineLayer.UnitAnimation.Perpetual.banana"])
    }

    func test_adding_and_removing_perpetual_animations_is_applied_to_the_target_layer() {
        subject.perpetual.add("grapefruit", CAAnimation())
        subject.perpetual.apply(to: layer)
        XCTAssertTrue(layer.animationKeys()?.contains("GraffeineLayer.UnitAnimation.Perpetual.grapefruit") ?? false)

        subject.perpetual.remove("grapefruit")
        subject.perpetual.apply(to: layer)
        XCTAssertFalse(layer.animationKeys()?.contains("GraffeineLayer.UnitAnimation.Perpetual.grapefruit") ?? false)
    }

    func test_removeAll_perpetual_animations_is_applied_to_the_target_layer() {
        subject.perpetual.add("banana", CAAnimation())
        subject.perpetual.add("kiwi", CAAnimation())
        subject.perpetual.apply(to: layer)
        XCTAssertTrue(layer.animationKeys()?.contains("GraffeineLayer.UnitAnimation.Perpetual.banana") ?? false)
        XCTAssertTrue(layer.animationKeys()?.contains("GraffeineLayer.UnitAnimation.Perpetual.kiwi") ?? false)

        subject.perpetual.removeAll()
        subject.perpetual.apply(to: layer)
        XCTAssertFalse(layer.animationKeys()?.contains("GraffeineLayer.UnitAnimation.Perpetual.banana") ?? false)
        XCTAssertFalse(layer.animationKeys()?.contains("GraffeineLayer.UnitAnimation.Perpetual.kiwi") ?? false)
    }

    func test_adding_and_removing_data_animations_key_retrieve() {
        let animator = GraffeineAnimation.Data.Bar.Grow(duration: 0.5, timing: .linear)
        subject.data.add(animator: animator, for: .reload)
        XCTAssertEqual(subject.data.semantics, [.reload])
    }
}
