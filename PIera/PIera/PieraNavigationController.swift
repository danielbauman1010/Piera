import UIKit

class PieraNavigationController: UINavigationController{
    var currentPerson: Person? = nil
    var students = [Student]()
    var teachers = [Teacher]()
    var experiments = [Experiment]()
    var server = Server(url: URL(string: "http://10.64.3.120:3000/")!)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTeacher"{
            //var DestViewController = segue.destinationViewController as! UINavigationController
            //let targetController = DestViewController.topViewController as! ReceiveViewController
            //targetController.data = "hello from ReceiveVC !"
            print("!")
        }
    }
}
