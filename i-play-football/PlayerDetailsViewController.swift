//
//  PlayerDetailsViewController.swift
//  i-play-football
//
//  Created by Massimiliano Federici on 12/01/2019.
//  Copyright © 2019 Massimiliano Federici. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class PlayerDetailsViewController: FormViewController {
    
    var player: Player?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    lazy var firstNameField: TextRow = TextRow() { row in
        row.title = "First Name *"
        row.placeholder = "First Name"
        row.add(rule: RuleRequired())
        row.value = player?.firstName
        row.validationOptions = .validatesOnChange
        row.cellUpdate(handleValidation)
        row.onChange {v in
            self.player = self.player?.withFirstName(v.value ?? "")
        }
    }
    
    lazy var lastNameField: TextRow = TextRow() { row in
        row.title = "Last Name *"
        row.placeholder = "Last Name"
        row.add(rule: RuleRequired())
        row.value = player?.lastName
        row.validationOptions = .validatesOnChange
        row.cellUpdate(handleValidation)
        row.onChange {v in
            self.player = self.player?.withLastName(v.value ?? "")
        }
    }
    
    lazy var dateOfBirthField: DateRow = DateRow() { row in
        row.title = "Date of Birth"
        row.value = player?.dateOfBirth
    }
    
    lazy var preferredPositionField: PushRow<String> = PushRow() { row in
        row.title = "Preferred Position"
        row.options = PlayerPosition.allCases.map{o in o.rawValue}
        row.value = player?.preferredPosition?.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< firstNameField
            <<< lastNameField
            <<< dateOfBirthField
            <<< preferredPositionField
        form.validate()
    }
    
    private func handleValidation(cell: TextCell, row: TextRow) {
        saveButton.isEnabled = isFormValid()
    }
    
    private func isFormValid() -> Bool {
        return form.allRows.flatMap{row in row.validationErrors}.isEmpty
    }
}
