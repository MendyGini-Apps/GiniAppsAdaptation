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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    func configure(whiteFilm film: Film?) {
        if let film = film {
            titleLabel.isHidden = false
            indicator.stopAnimating()
            titleLabel.text = film.title
        } else {
            titleLabel.isHidden = true
            indicator.isHidden = false
        }
    }
    
}
