import UIKit

class StoryboardLoader {
    static func loadViewController(from storyboardName: String, bundle: Bundle = .main) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }

    static func loadViewController<T: UIViewController>(from storyboardName: String, withID: String, bundle: Bundle = .main) -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: withID) as? T
    }
}
