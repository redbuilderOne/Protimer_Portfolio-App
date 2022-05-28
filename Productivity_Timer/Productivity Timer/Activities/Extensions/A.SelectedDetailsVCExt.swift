
import UIKit
import CoreData

extension ActivityDetailedViewController {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedIndexPath = tableView.indexPathForSelectedRow
        guard selectedIndexPath?.section != 1 || selectedIndexPath?.section != 3 || selectedIndexPath?.section != 5 else { return }

        if selectedIndexPath?.row == 1 {
            let titleRowEditAction = UIAlertController(title: "Edit Title", message: "Please edit the title", preferredStyle: .alert)
            titleRowEditAction.addTextField(configurationHandler: { (newTitle) -> Void in
                newTitle.text = self.activity.title
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })

            let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

                SelectedActivity.selectedActivity = self.activity

                self.activity.title = (titleRowEditAction.textFields?.first?.text)!

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
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            titleRowEditAction.addAction(okayAction)
            titleRowEditAction.addAction(cancelAction)
            self.present(titleRowEditAction, animated: true, completion: nil)
        }

        if selectedIndexPath?.row == 3 {
            let descRowEditAction = UIAlertController(title: "Edit Description", message: "Please edit the description", preferredStyle: .alert)
            descRowEditAction.addTextField(configurationHandler: { (newDescription) -> Void in
                newDescription.text = self.activity.desc
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })

            let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

                SelectedActivity.selectedActivity = self.activity
                self.activity.desc = (descRowEditAction.textFields?.first?.text)!

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
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            descRowEditAction.addAction(okayAction)
            descRowEditAction.addAction(cancelAction)
            self.present(descRowEditAction, animated: true, completion: nil)
        }
        if selectedIndexPath?.row == 5 {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            SelectedActivity.selectedActivity = self.activity

            if let selectedActivity = SelectedActivity.selectedActivity {

                if selectedActivity.fav {
                    selectedActivity.fav = false
                    print("\(selectedActivity) is now marked nonfavourite")
                } else {
                    selectedActivity.fav = true
                    print("\(selectedActivity) is now marked favourite")
                }

                do {

                    try context.save()
                    SelectedActivity.selectedActivity = nil
                } catch {
                    print("Can't save the context")
                }
            }
            tableView.reloadData()
        }
    }
}
