//
//  TeamViewController.swift
//  i-play-football
//
//  Created by Massimiliano Federici on 30/12/2018.
//  Copyright © 2018 Massimiliano Federici. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import ColorPickerRow

class TeamViewController: FormViewController {
    
    let persistence = TeamPersistence()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    lazy var team: Team = { [unowned self] in
        return self.persistence.load()
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
        self.team = self.team.withName(nameField.value ?? "")
            .withCoach(coachField.value ?? "")
            .withColour(colourField.value?.hexString() ?? "")
        persistence.save(team: self.team)
    }
    
    @IBAction func cancel() {
        self.team = persistence.load()
        setInitialValues()
        [nameField, coachField, colourField].forEach { row in row.reload() }
    }
    
    private func setInitialValues() {
        nameField.value = team.name
        coachField.value = team.coach
        colourField.value = UIColor(team.colour)
    }
}
