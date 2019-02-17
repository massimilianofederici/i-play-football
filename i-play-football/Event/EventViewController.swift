import Foundation
import Eureka

class EventViewController: FormViewController {
    
    let dateTimeFormat: String = "dd MMM yyyy HH:mm"
    
    var event: Event?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private lazy var eventTypeField: PushRow<String> = PushRow() { row in
        row.title = "Event Type"
        row.options = EventType.allCases.map{o in o.rawValue}
        row.add(rule: RuleRequired())
        row.cellUpdate{_,_ in self.handleValidation()}
        row.validationOptions = .validatesOnChange
        row.value = event?.type.rawValue
        row.onChange { v in
            let type = EventType.fromDescription(term: v.value)!
            let color = type.color().hexString()
            self.event?.type = type
            self.event?.categoryColor = color
        }
    }
    
    private lazy var titleField: TextRow = TextRow() { row in
        row.placeholder = "Title"
        row.add(rule: RuleRequired())
        row.cellUpdate{_,_ in self.handleValidation()}
        row.validationOptions = .validatesOnChange
        row.value = event?.title
        row.onChange { v in
            self.event?.title = v.value ?? ""
        }
    }
    
    private lazy var locationField: TextRow = TextRow() { row in
        row.placeholder = "Location"
        row.add(rule: RuleRequired())
        row.cellUpdate{_,_ in self.handleValidation()}
        row.validationOptions = .validatesOnChange
        row.value = event?.location
        row.onChange { v in
            self.event?.location = v.value ?? ""
        }
    }
    
    private lazy var startTimeField: DateTimeRow = DateTimeRow() { row in
        row.dateFormatter?.dateFormat = self.dateTimeFormat
        row.title = "Starts"
        row.add(rule: RuleRequired())
        row.cellUpdate{_,_ in self.handleValidation()}
        row.validationOptions = .validatesOnChange
        row.value = event?.startTime
        row.onChange { v in
            self.event?.startTime = v.value!
        }
    }
    
    private lazy var endTimeField: DateTimeRow = DateTimeRow() { row in
        row.dateFormatter?.dateFormat = self.dateTimeFormat
        row.title = "Ends"
        row.add(rule: RuleRequired())
        row.cellUpdate{_,_ in self.handleValidation()}
        row.validationOptions = .validatesOnChange
        row.value = event?.endTime
        row.onChange { v in
            self.event?.endTime = v.value!
        }
    }
    
    private lazy var notesField: TextAreaRow = TextAreaRow() { row in
        row.placeholder = "Notes"
        row.cellUpdate{_,_ in self.handleValidation()}
        row.value = event?.note
        row.onChange { v in
            self.event?.note = v.value!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< eventTypeField
            <<< titleField
            <<< locationField
            +++ Section()
            <<< startTimeField
            <<< endTimeField
            +++ Section()
            <<< notesField
        form.validate()
    }
    
    private func handleValidation() {
        saveButton.isEnabled = isFormValid()
    }
    
    private func isFormValid() -> Bool {
        return form.allRows.flatMap{row in row.validationErrors}.isEmpty
    }
}
