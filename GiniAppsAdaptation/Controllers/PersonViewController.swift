//
//  PersonViewController.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 22/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    
    class func instantiatePersonVC(withPerson person: People, andFilms films: [Film]?) -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "PersonNavigationController") as! UINavigationController
        if let personVC = navVC.visibleViewController as? PersonViewController {
            personVC.people = person
            if films != nil {
                personVC.films = films
            } else if let filmsCount = person.filmsStr?.count {
                personVC.films = [Film?](repeating: nil, count:filmsCount)
            }
            
        }
        return navVC
    }
    static let cellId = "CellId"
    
    private var people: People!
    private var films: [Film?]!
    
    
    @IBOutlet weak var containerHeaderView: UIView!
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var bottomBaseContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightBaseContainerConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBAction func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        
        if (films.first{$0 == nil}) != nil, let urls = people.filmsStr?.urls {
            _ = DownloadManager<Film>(urls: urls, delegate: self)
        }
    }
    
    private func configureView() {
        tableView.register(UINib(nibName: DetailsFilmCell.nibName, bundle: nil), forCellReuseIdentifier: PersonViewController.cellId)
        
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

}

extension PersonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonViewController.cellId, for: indexPath) as! DetailsFilmCell
        
        cell.configure(with: films[indexPath.row], isReady: films[indexPath.row] != nil)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        containerHeaderView.clipsToBounds = offsetY >= 0
        bottomBaseContainerConstraint.constant = offsetY <= 0 ? 0 : offsetY
        heightBaseContainerConstraint.constant = max(-offsetY, scrollView.contentInset.top)
    }
}

extension PersonViewController: DownloadManagerDelegate {
    func downloadFinished<T>(object: T, at index: Int, userInfo: [String : Any]?) where T : Decodable {
        if let film = object as? Film {
            self.films[index] = film
            let indexPath = IndexPath(row: index, section: 0)
            if let visibleRows = tableView.indexPathsForVisibleRows,
                visibleRows.contains(indexPath) {
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
}
























