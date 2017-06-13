import UIKit
import UserNotifications

class PieraNavigationController: UINavigationController{
    var currentPerson: Person? = nil
    var currentAdministration: Administration? = nil
    var server = Server(url: URL(string: "https://www.piera.tk")!)
    var debugMode: Bool = false
    var ucode = ""
    var ucodeType: personType = personType.None
    var currentExperiments = [Experiment]()
    var administrations: [Administration] = [Administration(name: "Default U", studentCode: "s", teacherCode: "t", adminCode: "a"), Administration(name: "Harvard", studentCode: "1234", teacherCode: "4321", adminCode: "2143")]
    var administrators : [Person] = []
    /*func filterTime(comparisonType: ComparisonResult)->[Experiment]{
     //orderedAscending - Past, orderedSame - Present, orderedDescending - Future
     return experiments.filter{($0.time?.compare(Date())) == comparisonType}
     }
     
     var currentExperiments: [Experiment]{
     return filterTime(comparisonType: .orderedDescending)
     }
     
     var pastExperiments: [Experiment]{
     return filterTime(comparisonType: .orderedAscending)
     }
     */
    
    fileprivate let ITEMS_KEY = "todoItems"
    func addItem(_ item: TodoItem) {
        // persist a representation of this todo item in UserDefaults
        var todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        UserDefaults.standard.set(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Experiment \(item.expName) will take place \(item.title) at \(item.location)" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline as Date // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}

enum personType{
    case Student, Teacher, Admin, None
}

struct TodoItem {
    var title: String
    var expName: String
    var location: String
    var deadline: Date
    var UUID: String
    
    init(deadline: Date, title: String, UUID: String, expName: String, location: String) {
        self.deadline = deadline
        self.title = title
        self.location = location
        self.expName = expName
        self.UUID = UUID
    }
}
