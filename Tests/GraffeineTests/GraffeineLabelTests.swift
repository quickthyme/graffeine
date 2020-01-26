import XCTest
@testable import Graffeine

class GraffeineLabelTests: XCTestCase {

    var view: UIView!
    var subject: GraffeineLabel!

    let viewFrame = CGRect(x: 0, y: 0, width: 100, height: 100)

    override func setUp() {
        view = UIView(frame: viewFrame)
        subject = GraffeineLabel()
        subject.position = .zero
        subject.bounds = view.bounds
        view.layer.addSublayer(subject)
        view.layoutSublayers(of: view.layer)
    }

    func test_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_TOP_LEFT_alignment_then_text_is_ailgned_top_left() {
        subject.alignment.vertical = .top
        subject.alignment.horizontal = .left
        subject.layoutIfNeeded()
        XCTAssertEqual(subject.text.alignmentMode, .left)
        XCTAssertEqual(subject.text.position, CGPoint(x: 0.0, y: 0.0))
        XCTAssertEqual(subject.text.anchorPoint, CGPoint(x: 0.0, y: 0.0))
    }

    func test_given_TOP_CENTER_alignment_then_text_is_ailgned_top_center() {
        subject.alignment.vertical = .top
        subject.alignment.horizontal = .center
        subject.layoutIfNeeded()
        XCTAssertEqual(subject.text.alignmentMode, .center)
        XCTAssertEqual(subject.text.position, CGPoint(x: 50.0, y: 0.0))
        XCTAssertEqual(subject.text.anchorPoint, CGPoint(x: 0.5, y: 0.0))
    }

    func test_given_TOP_RIGHT_alignment_then_text_is_ailgned_top_right() {
        subject.alignment.vertical = .top
        subject.alignment.horizontal = .right
        subject.layoutIfNeeded()
        XCTAssertEqual(subject.text.alignmentMode, .right)
        XCTAssertEqual(subject.text.position, CGPoint(x: 100.0, y: 0.0))
        XCTAssertEqual(subject.text.anchorPoint, CGPoint(x: 1.0, y: 0.0))
    }

    func test_given_CENTER_LEFT_alignment_then_text_is_ailgned_top_left() {
        subject.alignment.vertical = .center
        subject.alignment.horizontal = .left
        subject.layoutIfNeeded()
        XCTAssertEqual(subject.text.alignmentMode, .left)
        XCTAssertEqual(subject.text.position, CGPoint(x: 0.0, y: 50.0))
        XCTAssertEqual(subject.text.anchorPoint, CGPoint(x: 0.0, y: 0.5))
    }

    func test_given_CENTER_CENTER_alignment_then_text_is_ailgned_top_center() {
        subject.alignment.vertical = .center
        subject.alignment.horizontal = .center
        subject.layoutIfNeeded()
        XCTAssertEqual(subject.text.alignmentMode, .center)
        XCTAssertEqual(subject.text.position, CGPoint(x: 50.0, y: 50.0))
        XCTAssertEqual(subject.text.anchorPoint, CGPoint(x: 0.5, y: 0.5))
    }

    func test_given_CENTER_RIGHT_alignment_then_text_is_ailgned_top_right() {
        subject.alignment.vertical = .center
        subject.alignment.horizontal = .right
        subject.layoutIfNeeded()
        XCTAssertEqual(subject.text.alignmentMode, .right)
        XCTAssertEqual(subject.text.position, CGPoint(x: 100.0, y: 50.0))
        XCTAssertEqual(subject.text.anchorPoint, CGPoint(x: 1.0, y: 0.5))
    }

    func test_given_BOTTOM_LEFT_alignment_then_text_is_ailgned_top_left() {
        subject.alignment.vertical = .bottom
        subject.alignment.horizontal = .left
        subject.layoutIfNeeded()
        XCTAssertEqual(subject.text.alignmentMode, .left)
        XCTAssertEqual(subject.text.position, CGPoint(x: 0.0, y: 100.0))
        XCTAssertEqual(subject.text.anchorPoint, CGPoint(x: 0.0, y: 1.0))
    }

    func test_given_BOTTOM_CENTER_alignment_then_text_is_ailgned_top_center() {
        subject.alignment.vertical = .bottom
        subject.alignment.horizontal = .center
        subject.layoutIfNeeded()
        XCTAssertEqual(subject.text.alignmentMode, .center)
        XCTAssertEqual(subject.text.position, CGPoint(x: 50.0, y: 100.0))
        XCTAssertEqual(subject.text.anchorPoint, CGPoint(x: 0.5, y: 1.0))
    }

    func test_given_BOTTOM_RIGHT_alignment_then_text_is_ailgned_top_right() {
        subject.alignment.vertical = .bottom
        subject.alignment.horizontal = .right
        subject.layoutIfNeeded()
        XCTAssertEqual(subject.text.alignmentMode, .right)
        XCTAssertEqual(subject.text.position, CGPoint(x: 100.0, y: 100.0))
        XCTAssertEqual(subject.text.anchorPoint, CGPoint(x: 1.0, y: 1.0))
    }
}
