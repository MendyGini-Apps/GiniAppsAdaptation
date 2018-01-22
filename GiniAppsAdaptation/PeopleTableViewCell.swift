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
    @IBOutlet weak var portraitImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundLayerImage()
    }
    
    private func roundLayerImage() {
        portraitImageView.layer.cornerRadius = min(portraitImageView.bounds.width, portraitImageView.bounds.height)/2
        portraitImageView.layer.masksToBounds = true
    }
    
    func configure(withName name: String?, gender: String?, height: String?) {
        nameLabel.text = name
        genderLabel.text = gender
        heightLabel.text = height
        
        if let name = name,
            let image = UIImage(named: name) {
            portraitImageView.image = image
        } else {
            portraitImageView.image = nil
        }
    }
    
}
