import XCTest
@testable import Graffeine

class GraffeineVerticalLabelLayerTests: XCTestCase {

    typealias Label = GraffeineVerticalLabelLayer.Label

    var graffeineView: GraffeineView!
    var subject: GraffeineVerticalLabelLayer!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 300)

    var subjectLabels: [Label] {
        return subject.sublayers!.compactMap { $0 as? Label }
    }

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.leftGutter) as? GraffeineVerticalLabelLayer
    }

    func test_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_correct_number_of_labels() {
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.count, 11)
    }

    func test_given_horizontal_alignment_mode_left_when_positioned_then_they_are_all_left_aligned() {
        subject.labelHorizontalAlignmentMode = .left
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignmentMode, .left)
        XCTAssertEqual(labels[1].alignmentMode, .left)
        XCTAssertEqual(labels.last?.alignmentMode, .left)
    }

    func test_given_label_alignment_mode_right_when_positioned_then_they_are_all_right_aligned() {
        subject.labelHorizontalAlignmentMode = .right
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignmentMode, .right)
        XCTAssertEqual(labels[1].alignmentMode, .right)
        XCTAssertEqual(labels.last?.alignmentMode, .right)
    }

    func test_given_label_alignment_mode_center_when_positioned_then_they_are_all_centered() {
        subject.labelHorizontalAlignmentMode = .center
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignmentMode, .center)
        XCTAssertEqual(labels[1].alignmentMode, .center)
        XCTAssertEqual(labels.last?.alignmentMode, .center)
    }

    func test_given_label_alignment_mode_centerLeftRight_when_positioned_then_it_has_correct_label_alignments() {
        subject.labelHorizontalAlignmentMode = .centerLeftRight
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignmentMode, .left)
        XCTAssertEqual(labels[1].alignmentMode, .center)
        XCTAssertEqual(labels.last?.alignmentMode, .right)
    }

    func test_given_vertical_alignment_mode_top_when_positioned_then_they_are_all_aligned_top() {
        subject.labelVerticalAlignmentMode = .top
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(normalized(labels.first!.position), CGPoint(x: 0, y:   0.00))
        XCTAssertEqual(normalized(labels[1].position),     CGPoint(x: 0, y:  24.00))
        XCTAssertEqual(normalized(labels[2].position),     CGPoint(x: 0, y:  48.00))
        XCTAssertEqual(normalized(labels.last!.position),  CGPoint(x: 0, y: 240.00))
    }

    func test_given_vertical_alignment_mode_bottom_when_positioned_then_they_are_all_aligned_bottom() {
        subject.labelVerticalAlignmentMode = .bottom
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(normalized(labels.first!.position), CGPoint(x: 0, y:   4.00))
        XCTAssertEqual(normalized(labels[1].position),     CGPoint(x: 0, y:  28.00))
        XCTAssertEqual(normalized(labels[2].position),     CGPoint(x: 0, y:  52.00))
        XCTAssertEqual(normalized(labels.last!.position),  CGPoint(x: 0, y: 244.00))
    }

    func test_given_vertical_alignment_mode_center_when_positioned_then_they_are_all_aligned_center() {
        subject.labelVerticalAlignmentMode = .center
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(normalized(labels.first!.position), CGPoint(x: 0, y:   3.50))
        XCTAssertEqual(normalized(labels[1].position),     CGPoint(x: 0, y:  27.50))
        XCTAssertEqual(normalized(labels[2].position),     CGPoint(x: 0, y:  51.50))
        XCTAssertEqual(normalized(labels.last!.position),  CGPoint(x: 0, y: 243.50))
    }

    func test_given_vertical_alignment_mode_centerTopBottom_when_positioned_then_they_are_correct() {
        subject.labelVerticalAlignmentMode = .centerTopBottom
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(normalized(labels.first!.position), CGPoint(x: 0, y:   0.00))
        XCTAssertEqual(normalized(labels[1].position),     CGPoint(x: 0, y:  27.50))
        XCTAssertEqual(normalized(labels[2].position),     CGPoint(x: 0, y:  51.50))
        XCTAssertEqual(normalized(labels.last!.position),  CGPoint(x: 0, y: 244.00))
    }
}
