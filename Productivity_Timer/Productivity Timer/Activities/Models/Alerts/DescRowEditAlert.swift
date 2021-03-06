
import UIKit
import CoreData

struct DescRowEditAlert {
    func descRowEditAction(on vc: UIViewController, activity: Activity, tableView: UITableView) {
        
        let descRowEditAction = UIAlertController(title: "Edit Description", message: "Please edit the description", preferredStyle: .alert)
        descRowEditAction.addTextField(configurationHandler: { (newDescription) -> Void in
            newDescription.text = activity.desc
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            vc.presentingViewController?.dismiss(animated: true, completion: nil)
        })

        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

            SelectedActivity.selectedActivity = activity
            activity.desc = (descRowEditAction.textFields?.first?.text)!

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            if SelectedActivity.selectedActivity != nil {
                do {
                    try context.save()
                    SelectedActivity.selectedActivity = nil
                } catch {
                    print("Can't save the context")
                }
            }

            tableView.reloadData()
            vc.presentingViewController?.dismiss(animated: true, completion: nil)
        })

        descRowEditAction.addAction(okayAction)
        descRowEditAction.addAction(cancelAction)
        vc.present(descRowEditAction, animated: true, completion: nil)
    }
}
