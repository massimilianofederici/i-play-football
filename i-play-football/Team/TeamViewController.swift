import Foundation
import UIKit
import Eureka
import ColorPickerRow
import GRDB

class TeamViewController: FormViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    lazy var team: Team = {
        return try! dbQueue.read {try Team.all().limit(1).fetchAll($0).first} ?? Team.aTeam()
        }()
    
    lazy var nameField: TextRow = TextRow() { row in
        row.title = "Name"
        row.placeholder = "Team name"
        row.add(rule: RuleRequired())
        row.cellUpdate(handleValidation)
    }
    
    lazy var coachField: TextRow = TextRow() { row in
        row.title = "Coach"
        row.placeholder = "Coach Name"
        row.add(rule: RuleRequired())
        row.cellUpdate(handleValidation)
    }
    
    lazy var colourField: InlineColorPickerRow = InlineColorPickerRow() { row in
        row.title = "Colour"
        row.isCircular = false
        row.showsPaletteNames = false
    }
    
    private func handleValidation(cell: TextCell, row: TextRow) {
        if !row.isValid {
            cell.titleLabel?.textColor = .red
        }
        saveButton.isEnabled  = form.allRows.flatMap{row in row.validationErrors}.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ nameField
            <<< coachField
            <<< colourField
        setInitialValues()
    }
    
    @IBAction func save() {
        self.team.name = nameField.value!
        self.team.coach = coachField.value
        self.team.colour = colourField.value?.hexString()
        try! dbQueue.write{ db in
            try team.save(db)
        }
    }
    
    @IBAction func cancel() {
        setInitialValues()
        [nameField, coachField, colourField].forEach { row in row.reload() }
    }
    
    private func setInitialValues() {
        nameField.value = team.name
        coachField.value = team.coach
        team.colour.map{UIColor($0)}.map{colourField.value = $0}
    }
}
