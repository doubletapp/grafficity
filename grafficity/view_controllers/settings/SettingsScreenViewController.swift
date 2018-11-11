//
//  SettingsScreenViewController.swift
//  Grafficity
//
//  Created by Hash on 10/11/2018.
//  Copyright © 2018 doubletapp. All rights reserved.
//

import Foundation
import UIKit

class SettingsScreenViewController: UITableViewController {
    
    var cellDescriptions: [TableViewCellDescription] = []

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
}


