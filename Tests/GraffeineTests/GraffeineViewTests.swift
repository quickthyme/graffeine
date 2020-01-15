import XCTest
@testable import Graffeine

class GraffeineViewTests: XCTestCase {

    var subject: GraffeineView!

    let someLayers: [GraffeineLayer] = [
        GraffeineLayer(),
        GraffeineLayer(),
        GraffeineLayer()
    ]

    let subjectFrame = CGRect(x: 0, y: 0, width: 300, height: 200)

    override func setUp() {
        subject = GraffeineView(frame: subjectFrame)
    }

    func test_construct_default_view_does_not_fail() {
        XCTAssertNotNil(subject)
    }

    func test_construct_default_layer_does_not_fail() {
        let layer = GraffeineLayer()
        XCTAssertNotNil(layer)
    }

    func test_when_setting_all_layers_at_once_then_it_adds_them_as_sublayers_in_like_order() {
        subject.layers = someLayers

        XCTAssertEqual(subject.layer.sublayers!.count, 3)

        XCTAssert(someLayers[0] === subject.layer.sublayers![0])
        XCTAssert(someLayers[0].superlayer === subject.layer)

        XCTAssert(someLayers[1] === subject.layer.sublayers![1])
        XCTAssert(someLayers[1].superlayer === subject.layer)

        XCTAssert(someLayers[2] === subject.layer.sublayers![2])
        XCTAssert(someLayers[2].superlayer === subject.layer)
    }

    func test_given_layers_exist_when_inserting_new_layers_then_it_adds_them_as_sublayers_in_correct_positions() {
        subject.layers = someLayers

        let newLayer1 = GraffeineLayer()
        let newLayer2 = GraffeineLayer()
        subject.layers.insert(newLayer2, at: 2)
        subject.layers.insert(newLayer1, at: 1)

        XCTAssertEqual(subject.layer.sublayers!.count, 5)

        XCTAssert(someLayers[0].superlayer === subject.layer)
        XCTAssert(someLayers[0] === subject.layer.sublayers![0])

        XCTAssert(newLayer1.superlayer === subject.layer)
        XCTAssert(newLayer1 === subject.layer.sublayers![1])

        XCTAssert(someLayers[1].superlayer === subject.layer)
        XCTAssert(someLayers[1] === subject.layer.sublayers![2])

        XCTAssert(newLayer2.superlayer === subject.layer)
        XCTAssert(newLayer2 === subject.layer.sublayers![3])

        XCTAssert(someLayers[2].superlayer === subject.layer)
        XCTAssert(someLayers[2] === subject.layer.sublayers![4])
    }

    func test_when_layers_are_set_with_no_gutters_then_the_main_region_frame_should_match_the_view_bounds() {
        subject.layers = [
            GraffeineLineLayer(id: 1)
        ]
        let expectedFrame = subjectFrame
        XCTAssertEqual(subject.layer(id: 1)?.frame, expectedFrame)
    }

    func test_when_layers_are_set_that_include_gutters_then_all_region_frames_should_be_properly_positioned() {
        subject.layers = [
            GraffeineHorizontalGutter(id: "topGutter", height: 20, region: .topGutter),
            GraffeineVerticalGutter(id: "rightGutter", width: 20, region: .rightGutter),
            GraffeineHorizontalGutter(id: "bottomGutter", height: 20, region: .bottomGutter),
            GraffeineVerticalGutter(id: "leftGutter", width: 20, region: .leftGutter),
            GraffeineLineLayer(id: "mainRegion")
        ]
        XCTAssertEqual(subject.layer(id: "topGutter")?.frame,    CGRect(x: 20,  y: 0,   width: 260, height: 20))
        XCTAssertEqual(subject.layer(id: "rightGutter")?.frame,  CGRect(x: 280, y: 20,  width: 20,  height: 160))
        XCTAssertEqual(subject.layer(id: "bottomGutter")?.frame, CGRect(x: 20,  y: 180, width: 260, height: 20))
        XCTAssertEqual(subject.layer(id: "leftGutter")?.frame,   CGRect(x: 0,   y: 20,  width: 20,  height: 160))
        XCTAssertEqual(subject.layer(id: "mainRegion")?.frame,   CGRect(x: 20,  y: 20,  width: 260, height: 160))
    }

    func test_auto_load_config_from_class_name_set_in_IB() {
        subject.configClass = "SampleConfig"
        subject.awakeFromNib()
        XCTAssertEqual(subject.layers.count, 11)
        XCTAssert(subject.layers[ 0] is GraffeineHorizontalGutter)
        XCTAssert(subject.layers[ 1] is GraffeineVerticalGutter)
        XCTAssert(subject.layers[ 2] is GraffeineHorizontalGutter)
        XCTAssert(subject.layers[ 3] is GraffeineVerticalGutter)
        XCTAssert(subject.layers[ 4] is GraffeineGridLineLayer)
        XCTAssert(subject.layers[ 5] is GraffeineBarLayer)
        XCTAssert(subject.layers[ 6] is GraffeineBarLayer)
        XCTAssert(subject.layers[ 7] is GraffeineLineLayer)
        XCTAssert(subject.layers[ 8] is GraffeineLineLayer)
        XCTAssert(subject.layers[ 9] is GraffeinePlotLayer)
        XCTAssert(subject.layers[10] is GraffeineGridLineLayer)
    }
}
