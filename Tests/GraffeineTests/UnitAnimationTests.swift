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

    func test_adding_and_removing_animations_is_applied_to_the_target_layer() {
        subject.add("grapefruit", CAAnimation())
        subject.apply(to: layer)
        XCTAssertTrue(layer.animationKeys()?.contains("GraffeineLayer.UnitAnimation.grapefruit") ?? false)

        subject.remove("grapefruit")
        subject.apply(to: layer)
        XCTAssertFalse(layer.animationKeys()?.contains("GraffeineLayer.UnitAnimation.grapefruit") ?? false)
    }
}
