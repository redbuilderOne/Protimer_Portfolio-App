
import UIKit
import CoreData

class NewActivityViewController: UIViewController, NewActivityViewActions, RemovableTextWithAlert {

    lazy var newActivityView = CreateNewActivityView()
    lazy var conformAlert = Alert(delegate: self)

    static var selectedActivity: Activity? = nil

    lazy var newActivityTitle = String()
    lazy var newActivityDescription = String()

    override func loadView() {
        view = newActivityView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Activity"
        newActivityView.delegate = self
        newActivityView.textField.delegate = self
        configureView()
        addSaveItem()
        checkSelectedActivity()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureView()
        addSaveItem()
    }

    func checkSelectedActivity() {
        if NewActivityViewController.selectedActivity != nil {
            title = "Editing"
            newActivityView.titleLabel.text = "Title"
            newActivityView.textField.text = NewActivityViewController.selectedActivity!.title
            newActivityView.descriptionLabel.text = "Description"
            newActivityView.descriptionTextView.text = NewActivityViewController.selectedActivity!.desc
        } else {
            title = "New Activity"
            newActivityView.titleLabel.text = "Your activity is..."
            newActivityView.textField.text = ""
            newActivityView.descriptionLabel.text = "Add description"
            newActivityView.descriptionTextView.text = ""
        }
    }

    final private func configureView() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = sandyYellowColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem()
        view.backgroundColor = darkMoonColor
    }

    private func addSaveItem() {
        let saveItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = saveItem
    }

    @objc func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        if NewActivityViewController.selectedActivity == nil {
            let entity = NSEntityDescription.entity(forEntityName: "Activity", in: context)
            let newActivity = Activity(entity: entity!, insertInto: context)
            newActivity.id = ActivitiesObject.arrayOfActivities.count as NSNumber
            newActivity.title = newActivityView.textField.text
            newActivity.desc = newActivityView.descriptionTextView.text
            newActivity.fav = false

            do {
                try context.save()
                ActivitiesObject.arrayOfActivities.append(newActivity)
            } catch {
                print("Can't save the context")
            }
        }

        if newActivityView.textField.text == "" {
            conformAlert.isEmptyTextFields(on: self, with: "Nah", message: "The text field can't be empty")
            return

        } else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {

                    let activity = result as! Activity
                    if activity == NewActivityViewController.selectedActivity {
                        activity.title = newActivityView.textField.text
                        activity.desc = newActivityView.descriptionTextView.text
                        try context.save()
                    }
                }
            } catch {
                print("Fetch failed")
            }
        }
    }

    //MARK: - Buttons actions
    func clearButtonDidPressed() {
        if newActivityView.textField.text == "" {
            conformAlert.isEmptyTextFields(on: self, with: "Oops", message: "Nothing to clear")
            return
        }
        conformAlert.textClearAlert(on: self, with: "Are you sure?", message: "This will delete all the text")
    }

    func removeText() {
        newActivityView.textField.text = ""
        newActivityView.descriptionTextView.text = ""
    }

    func okButtonDidPressed() {
        saveData()
        NewActivityViewController.selectedActivity = nil
        navigationController?.popViewController(animated: true)
    }
}