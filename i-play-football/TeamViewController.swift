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
    
    var team: Team?
    let persistence = TeamPersistence()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.team = persistence.load()
        form +++ Section("Team")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Team name"
                row.add(rule: RuleRequired())
                row.value = team?.name
                }.onChange { row in
                    self.team = self.team?.withName(teamName: row.value ?? "")
            }
            <<< TextRow(){ row in
                row.title = "Coach"
                row.placeholder = "Coach Name"
                row.value = team?.coach
                }.onChange { row in
                    self.team = self.team?.withCoach(coach: row.value ?? "")
            }
            <<< InlineColorPickerRow(){ row in
                row.title = "Colour"
                row.isCircular = false
                row.showsPaletteNames = false
                row.value = UIColor( team?.colour ?? "")
                }.onChange { row in
                    self.team = self.team?.withColour(colour: row.value?.hexString() ?? "")
            }
            <<< TextAreaRow(){ row in
                row.title = "Notes"
                row.placeholder = "Notes or description"
                row.value = team?.notes
                }.onChange { row in
                    self.team = self.team?.withNotes(notes: row.value)
        }
    }
    
    
    
    @IBAction func save() {
        persistence.save(team: self.team!)
    }
    
    @IBAction func cancel() {
        print("cancel")
    }
}
