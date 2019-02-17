import Foundation
import UIKit
import Eureka
import ImageRow

class PlayerDetailsViewController: FormViewController {
    
    var player: Player?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    lazy var firstNameField: TextRow = TextRow() { row in
        row.placeholder = "First Name"
        row.add(rule: RuleRequired())
        row.value = player?.firstName
        row.validationOptions = .validatesOnChange
        row.cellUpdate{_,_ in self.handleValidation()}
        row.onChange {v in
            self.player?.firstName = v.value ?? ""
        }
    }
    
    lazy var lastNameField: TextRow = TextRow() { row in
        row.placeholder = "Last Name"
        row.add(rule: RuleRequired())
        row.value = player?.lastName
        row.validationOptions = .validatesOnChange
        row.cellUpdate{_,_ in self.handleValidation()}
        row.onChange {v in
            self.player?.lastName = v.value ?? ""
        }
    }
    
    lazy var notesField: TextAreaRow = TextAreaRow() { row in
        row.placeholder = "Notes"
        row.value = player?.notes
        row.cellUpdate{_,_ in self.handleValidation()}
        row.onChange {v in
            self.player?.notes = v.value
        }
    }
    
    lazy var dateOfBirthField: DateRow = DateRow() { row in
        row.title = "Date of Birth"
        row.value = player?.dateOfBirth
        row.cellUpdate{_,_ in self.handleValidation()}
        row.onChange { v in
            self.player?.dateOfBirth = v.value
        }
    }
    
    lazy var preferredPositionField: PushRow<String> = PushRow() { row in
        row.title = "Preferred Position"
        row.options = PlayerPosition.allCases.map{o in o.rawValue}
        row.value = player?.preferredPosition?.rawValue
        row.cellUpdate{_,_ in self.handleValidation()}
        row.onChange { v in
            self.player?.preferredPosition = PlayerPosition.fromDescription(term: v.value)
        }
    }
    
    lazy var pictureField: ImageRow = ImageRow() { row in
        row.title = "Add a photo"
        row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
        row.clearAction = .yes(style: UIAlertAction.Style.destructive)
        if let data = player?.profilePicture {
            row.value = UIImage(data: data)
        }
        row.cellUpdate{_,_ in self.handleValidation()}
        row.onChange { v in
            let imageData:Data? = v.value?.jpegData(compressionQuality: 1.0)
            self.player?.profilePicture = imageData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< firstNameField
            <<< lastNameField
            <<< dateOfBirthField
            <<< preferredPositionField
            <<< notesField
            <<< pictureField
        form.validate()
    }
    
    private func handleValidation() {
        saveButton.isEnabled = isFormValid()
    }
    
    private func isFormValid() -> Bool {
        return form.allRows.flatMap{row in row.validationErrors}.isEmpty
    }
}
