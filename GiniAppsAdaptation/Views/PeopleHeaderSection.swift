//
//  PeopleHeaderSection.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 22/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class Section {
    var people: People
    var isCollapse: Bool
    
    init(people: People) {
        self.people = people
        isCollapse = true
    }
}

class PeopleHeaderSection: UITableViewHeaderFooterView {
    
    static let nibName = "PeopleHeaderSection"
    
    var isCollapse = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.collapseButton.transform = self.isCollapse ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat.pi*0.5)
            }
            
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var collapseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collapseButton.transform = self.isCollapse ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat.pi*0.5)
        
        roundLayerImage()
    }
    
    private func roundLayerImage() {
        portraitImageView.layer.cornerRadius = min(portraitImageView.bounds.width, portraitImageView.bounds.height)/2
        portraitImageView.layer.masksToBounds = true
    }
    
    func configure(withSection section: Section) {
        nameLabel.text = section.people.name
        genderLabel.text = section.people.gender
        heightLabel.text = section.people.height
        
        isCollapse = section.isCollapse
        
        portraitImageView.image = UIImage(named: section.people.name ?? "") ?? #imageLiteral(resourceName: "noImage")
    }
    
}
