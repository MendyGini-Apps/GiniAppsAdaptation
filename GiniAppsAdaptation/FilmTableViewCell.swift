//
//  FilmTableViewCell.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 21/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class FilmTableViewCell: UITableViewCell {
    
    static let nibName = "FilmTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(withTitle title: String?) {
        titleLabel.text = title
    }
    
}
