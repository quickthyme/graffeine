import XCTest
@testable import Graffeine

class GraffeineView_NotificationTests: XCTestCase {

    var subject: SpyGraffeineView!
    let subjectFrame = CGRect(x: 0, y: 0, width: 300, height: 200)

    override func setUp() {
        subject = SpyGraffeineView(frame: subjectFrame)
    }

    func test_it_observes_app_background_and_foreground_notifications() {
        XCTAssert(subject.mockNotificationCenter
            .didAddObserver(subject!, for: UIApplication.didEnterBackgroundNotification))
        XCTAssert(subject.mockNotificationCenter
            .didAddObserver(subject!, for: UIApplication.didBecomeActiveNotification))
    }

    func test_when_app_enters_background_then_it_disables_animations() {
        subject.applicationDidEnterBackground()
        XCTAssertEqual(subject.timesCalled_pauseAllAnimations, 1)
    }

    func test_when_app_enters_foreground_then_it_reactivates_sublayers() {
        subject.applicationDidBecomeActive()
        XCTAssertEqual(subject.timesCalled_layoutSublayers, 1)
    }
}

extension GraffeineView_NotificationTests {

    class SpyGraffeineView: GraffeineView {
        let mockNotificationCenter = MockNotificationCenter()
        override var notificationCenter: NotificationCenterInterface {
            return mockNotificationCenter
        }
        var timesCalled_layoutSublayers: Int = 0
        override func layoutSublayers(of layer: CALayer) {
            timesCalled_layoutSublayers += 1
            super.layoutSublayers(of: layer)
        }
        var timesCalled_pauseAllAnimations: Int = 0
        override func pauseAllAnimations() {
            timesCalled_pauseAllAnimations += 1
            super.pauseAllAnimations()
        }
    }

    class MockNotificationCenter: NotificationCenterInterface {
        var added: [(observer: Any, name: NSNotification.Name)] = []
        var removed: [(observer: Any, name: NSNotification.Name)] = []

        func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
            added.append((observer: observer, name: aName!))
        }

        func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
            removed.append((observer: observer, name: aName!))
        }

        func didAddObserver(_ observer: Any, for aName: NSNotification.Name?) -> Bool {
            return added.contains(where: {
                ($0.observer as AnyObject) === (observer as AnyObject)
                    && $0.name == aName
            })
        }

        func didRemoveObserver(_ observer: Any, for aName: NSNotification.Name?) -> Bool {
            return removed.contains(where: {
                ($0.observer as AnyObject) === (observer as AnyObject)
                    && $0.name == aName
            })
        }
    }
}
