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
            if let filmsCount = person.filmsStr?.count {
                personVC.films = [Film?](repeating: nil, count:filmsCount)
            }
            
        }
        return navVC
    }
    static let cellId = "CellId"
    
    var people: People!
    var films: [Film?]!
    
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        if let urls = people.filmsStr?.urls {
            _ = DownloadManager(urls: urls, delegate: self)
        }
    }
    
    func configureView() {
        tableView.register(UINib(nibName: FilmCell.nibName, bundle: nil), forCellReuseIdentifier: PersonViewController.cellId)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        
        navigationItem.title = people.name
        if let name = people.name,
            let image = UIImage(named: name) {
            portraitImageView.image = image
        }
        heightLabel.text = people.height?.appending(" cm")
        massLabel.text = people.mass?.appending(" kg")
        genderLabel.text = people.gender
    }
    
    @IBAction func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

}

extension PersonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonViewController.cellId, for: indexPath) as! FilmCell
        
        cell.configure(with: films[indexPath.row], isReady: films[indexPath.row] != nil)
        
        return cell
    }
}

extension PersonViewController: DownloadManagerDelegate {
    func downloadManager(_ manager: DownloadManager, FilmForIndex film: Film, atIndex index: Int) {
        self.films[index] = film
        let indexPath = IndexPath(row: index, section: 0)
        if let visibleRows = tableView.indexPathsForVisibleRows,
            visibleRows.contains(indexPath) {
            
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}
























