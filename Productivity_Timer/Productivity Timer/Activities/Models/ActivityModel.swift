
import Foundation

struct Activity {
    var title: String
    var description: String?
    var isFavourite: Bool
    var timeSpent: String?

    func createNewActivity(title: String, description: String) -> Activity {
        let newActivity = Activity(title: title, description: description, isFavourite: false)
        return newActivity
    }
}
