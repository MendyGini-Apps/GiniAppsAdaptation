//
//  ActorCell.swift
//  GiniAppsAdaptation
//
//  Created by Mendy Barouk on 23/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class ActorCell: UITableViewCell {
    
    static let nibName = "ActorCell"

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
        
        portraitImageView.image = UIImage(named: name ?? "") ?? #imageLiteral(resourceName: "noImage")
    }
    
}
