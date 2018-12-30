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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Team")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Team name"
            }
            <<< TextRow(){ row in
                row.title = "Coach"
                row.placeholder = "Coach Name"
            }
            <<< InlineColorPickerRow(){ row in
                row.title = "Colour"
                row.isCircular = false
                row.showsPaletteNames = false
            }
            +++ Section("Players")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
        }
    }
    
}
