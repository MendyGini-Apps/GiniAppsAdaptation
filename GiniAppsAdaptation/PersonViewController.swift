//
//  PersonViewController.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 22/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    
    class func instantiatePersonVC(withPerson person: People) -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "PersonNavigationController") as! UINavigationController
        if let personVC = navVC.visibleViewController as? PersonViewController {
            personVC.people = person
        }
        return navVC
    }
    
    var people: People!
    
    @IBOutlet weak var portraitImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = people.name,
            let image = UIImage(named: name) {
            portraitImageView.image = image
        }
    }
    
    @IBAction func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
