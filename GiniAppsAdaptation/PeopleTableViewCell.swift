//
//  PeopleTableViewCell.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 21/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    static let nibName = "PeopleTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    func configure(withName name: String?, gender: String?, height: String?) {
        self.nameLabel.text = name
        self.genderLabel.text = gender
        self.heightLabel.text = height
    }
    
}
