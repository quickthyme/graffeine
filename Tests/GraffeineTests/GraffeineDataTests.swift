import XCTest
@testable import Graffeine

class GraffeineDataTests: XCTestCase {

    var subject: GraffeineData!

    override func setUp() {
        subject = GraffeineData()
    }

    func test_init_empty() {
        let subject = GraffeineData()
        XCTAssertNil(subject.valueMax)
        XCTAssertEqual(subject.values.hi, [])
        XCTAssertEqual(subject.values.lo, [])
        XCTAssertEqual(subject.labels, [])
        XCTAssertEqual(subject.selected.labels, [])
        XCTAssertNil(subject.selected.index)
    }

    func test_init_hi_lo() {
        let subject = GraffeineData(valueMax: 200,
                                    valueMin: 100,
                                    valuesHi: [1, 2],
                                    valuesLo: [3, 4],
                                    labels: ["A", "B"],
                                    selectedLabels: ["C", "D"],
                                    selectedIndex: 1)
        XCTAssertEqual(subject.valueMax, 200)
        XCTAssertEqual(subject.valueMin, 100)
        XCTAssertEqual(subject.values.hi, [1, 2])
        XCTAssertEqual(subject.values.lo, [3, 4])
        XCTAssertEqual(subject.labels, ["A", "B"])
        XCTAssertEqual(subject.selected.labels, ["C", "D"])
        XCTAssertEqual(subject.selected.index!, 1)
    }

    func test_init_coordinates() {
        let subject = GraffeineData(coordinates: [(x: 3, y:1), (x: 1, y:0)],
                                    selectedIndex: 0)
        XCTAssertNil(subject.valueMax)
        XCTAssertEqual(subject.valueMaxOrSumHi, 4)
        XCTAssertEqual(subject.valueMaxOrSumLo, 1)
        XCTAssertEqual(subject.values.hi, [3, 1])
        XCTAssertEqual(subject.values.lo, [1, 0])
        XCTAssertEqual(subject.selected.index!, 0)
    }

    func test_highestHi() {
        subject.values.hi = [0, nil, 5, 38]
        XCTAssertEqual(subject.highestHi, 38)
    }

    func test_highestLo() {
        subject.values.lo = [0, nil, 5, 38]
        XCTAssertEqual(subject.highestLo, 38)
    }

    func test_lowestHi() {
        subject.values.hi = [106, 55, 12, 44, 99]
        XCTAssertEqual(subject.lowestHi, 12)
    }

    func test_lowestLo() {
        subject.values.lo = [106, 55, 12, 44, 99]
        XCTAssertEqual(subject.lowestLo, 12)
    }

    func test_lowestLo_with_nil() {
        subject.values.lo = [106, 55, 12, nil, 99]
        XCTAssertEqual(subject.lowestLo, 0)
    }

    func test_sumHi() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        XCTAssertEqual(subject.sumHi, 50)
    }

    func test_sumLo() {
        subject.values.lo = [5, 10, nil, 15, 20, nil]
        XCTAssertEqual(subject.sumLo, 50)
    }

    func test_valueMaxOrSumHi_given_no_valueMax() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        XCTAssertEqual(subject.valueMaxOrSumHi, 50)
    }

    func test_valueMaxOrSumHi_given_valueMax() {
        subject.valueMax = 100
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        XCTAssertEqual(subject.valueMaxOrSumHi, 100)
    }

    func test_valueMaxOrSumLo_given_no_valueMax() {
        subject.values.lo = [5, 10, nil, 15, 20, nil]
        XCTAssertEqual(subject.valueMaxOrSumLo, 50)
    }

    func test_valueMaxOrSumLo_given_valueMax() {
        subject.valueMax = 100
        subject.values.lo = [5, 10, nil, 15, 20, nil]
        XCTAssertEqual(subject.valueMaxOrSumLo, 100)
    }

    func test_valueMaxOrHighestHi_given_no_valueMax() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        XCTAssertEqual(subject.valueMaxOrHighestHi, 20)
    }

    func test_valueMaxOrHighestHi_given_valueMax() {
        subject.valueMax = 100
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        XCTAssertEqual(subject.valueMaxOrHighestHi, 100)
    }

    func test_loValueOrZero_given_index_but_no_lo_values_should_be_zero() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        subject.values.lo = []
        XCTAssertEqual(subject.loValueOrZero(3), 0)
    }

    func test_loValueOrZero_given_index_out_of_range_should_give_zero() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        subject.values.lo = [8, 16, 24, 32, 48, nil]
        XCTAssertEqual(subject.loValueOrZero(99), 0)
    }

    func test_loValueOrZero_given_index_within_range_should_give_lo_value() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        subject.values.lo = [8, 16, 24, 32, 48, nil]
        XCTAssertEqual(subject.loValueOrZero(4), 48)
    }

    func test_preferredLabelValue_given_index_but_no_selection_should_return_normal_label() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        subject.labels = ["jan", "feb", "mar", "apr", "may", "jun"]
        subject.selected.labels = ["jul", "aug", "sep", "oct", "nov", "dec"]
        XCTAssertEqual(subject.preferredLabelValue(2), "mar")
    }

    func test_preferredLabelValue_given_index_but_selection_out_of_range_should_return_normal_label() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        subject.labels = ["jan", "feb", "mar", "apr", "may", "jun"]
        subject.selected.labels = ["2000", "2001"]
        XCTAssertEqual(subject.preferredLabelValue(4), "may")
    }

    func test_preferredLabelValue_given_index_but_not_matching_selection_should_return_normal_label() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        subject.labels = ["jan", "feb", "mar", "apr", "may", "jun"]
        subject.selected.labels = ["jul", "aug", "sep", "oct", "nov", "dec"]
        subject.selected.index = 5
        XCTAssertEqual(subject.preferredLabelValue(3), "apr")
    }

    func test_preferredLabelValue_given_index_and_selection_within_range_should_return_selected_label() {
        subject.values.hi = [5, 10, nil, 15, 20, nil]
        subject.labels = ["jan", "feb", "mar", "apr", "may", "jun"]
        subject.selected.labels = ["jul", "aug", "sep", "oct", "nov", "dec"]
        subject.selected.index = 5
        XCTAssertEqual(subject.preferredLabelValue(5), "dec")
    }

    func test_static_getPercent_given_divie_by_zero_should_return_zero_not_inf() {
        let val = GraffeineData.getPercent(of: 5, in: 0)
        XCTAssertEqual(val, 0)
    }

    func test_static_getPercent_given_valid_input_should_return_fraction() {
        let val = GraffeineData.getPercent(of: 5, in: 10)
        XCTAssertEqual(val, 0.5)
    }

    func test_static_convertHiLo_given_two_numbers_returns_them_sorted_as_hi_and_lo() {
        let val = GraffeineData.convertHiLo(5, 10)
        XCTAssertEqual(val.0, 10)
        XCTAssertEqual(val.1, 5)
    }

    func test_static_invertPairs_given_a_pair_of_arrays_returns_them_as_one_array_of_pairs() {
        let val = GraffeineData.invertPairs(([1.0, 3.0, 5.0], [2.0, 4.0, 6.0]))
        XCTAssertEqual(val.count, 3)
        XCTAssertEqual(val[0].0, 1.0)
        XCTAssertEqual(val[0].1, 2.0)
        XCTAssertEqual(val[1].0, 3.0)
        XCTAssertEqual(val[1].1, 4.0)
        XCTAssertEqual(val[2].0, 5.0)
        XCTAssertEqual(val[2].1, 6.0)
    }

    func test_static_invertPairs_given_an_array_of_pairs_returns_them_as_a_pair_of_arrays() {
        let val = GraffeineData.invertPairs([(1.0, 2.0), (3.0, 4.0), (5.0, 6.0)])
        XCTAssertEqual(val.0, [1.0, 3.0, 5.0])
        XCTAssertEqual(val.1, [2.0, 4.0, 6.0])
    }

    func test_when_transposed_with_only_positive_values_then_no_change() {
        let original = GraffeineData(valuesHi: [0, 1, 2, 3, 4, 5])
        let transposed = GraffeineData(transposed: original)
        XCTAssertEqual(transposed.values.hi, [0, 1, 2, 3, 4, 5])
        XCTAssertEqual(transposed.values.lo, [])
    }

    func test_when_transposed_with_negative_values_then_offset_based_on_best_guess() {
        let original = GraffeineData(valuesHi: [0, 1, 2, 3, 4, 5, -5])
        let transposed = GraffeineData(transposed: original)
        XCTAssertEqual(transposed.valueMax, 10)
        XCTAssertEqual(transposed.valueMin,  0)
        XCTAssertEqual(transposed.values.hi, [5, 6, 7, 8, 9, 10, 5])
        XCTAssertEqual(transposed.values.lo, [5, 5, 5, 5, 5,  5, 0])
    }

    func test_when_transposed_with_negative_values_and_provided_range_then_offset_accordingly() {
        let original = GraffeineData(valueMax: 10, valueMin: -10, valuesHi: [0, 1, 2, 3, 4, 5, -5])
        let transposed = GraffeineData(transposed: original)
        XCTAssertEqual(transposed.valueMax, 20)
        XCTAssertEqual(transposed.valueMin,  0)
        XCTAssertEqual(transposed.values.hi, [10, 11, 12, 13, 14, 15, 10])
        XCTAssertEqual(transposed.values.lo, [10, 10, 10, 10, 10, 10,  5])
    }

    func test_when_transposed_with_negative_values_and_provided_max_value_then_offset_accordingly() {
        let original = GraffeineData(valueMax: 10, valuesHi: [0, 1, 2, 3, 4, 5, -10])
        let transposed = GraffeineData(transposed: original)
        XCTAssertEqual(transposed.valueMax, 20)
        XCTAssertEqual(transposed.valueMin,  0)
        XCTAssertEqual(transposed.values.hi, [10, 11, 12, 13, 14, 15, 10])
        XCTAssertEqual(transposed.values.lo, [10, 10, 10, 10, 10, 10,  0])
    }

    func test_when_transposed_with_negative_hi_and_lo_values_then_ignores_original_lo_vals() {
        let original = GraffeineData(valueMax: 10, valueMin: -10, valuesHi: [0, 1, 2, 3, 4, 5, -1], valuesLo: [0, -1, -2, -3, -4, -5, -6])
        let transposed = GraffeineData(transposed: original)
        XCTAssertEqual(transposed.valueMax, 20)
        XCTAssertEqual(transposed.valueMin,  0)
        XCTAssertEqual(transposed.values.hi, [10, 11, 12, 13, 14, 15, 10])
        XCTAssertEqual(transposed.values.lo, [10, 10, 10, 10, 10, 10,  9])
    }
}
