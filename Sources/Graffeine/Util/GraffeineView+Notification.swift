import UIKit

internal protocol NotificationCenterInterface {
    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NSNotification.Name?,
                     object anObject: Any?)
    func removeObserver(_ observer: Any,
                        name aName: NSNotification.Name?,
                        object anObject: Any?)
}

extension NotificationCenter: NotificationCenterInterface {}

internal extension GraffeineView {

    func setupNotifications() {
        notificationCenter.addObserver(self,
                                       selector: #selector(applicationDidEnterBackground),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(applicationDidBecomeActive),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)
    }

    func tearDownNotifications() {
        notificationCenter.removeObserver(self,
                                          name: UIApplication.didEnterBackgroundNotification,
                                          object: nil)
        notificationCenter.removeObserver(self,
                                          name: UIApplication.didBecomeActiveNotification,
                                          object: nil)
    }

    @objc func applicationDidEnterBackground() {
        for layer in layers { layer.removeAllAnimations() }
        self.pauseAllAnimations()
    }

    @objc func applicationDidBecomeActive() {
        self.layoutSublayers(of: self.layer)
    }
}
