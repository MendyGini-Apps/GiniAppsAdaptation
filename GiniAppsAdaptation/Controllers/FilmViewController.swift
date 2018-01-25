//
//  FilmViewController.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 23/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class FilmViewController: UIViewController {
    
    class func instantiateFilmVC(withFilm film: Film) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filmVC = storyboard.instantiateViewController(withIdentifier: "FilmViewController") as! FilmViewController
        
        filmVC.film = film
        filmVC.people = [People?](repeating: nil, count:film.personsUrl?.count ?? 0)
        
        return filmVC
    }
    
    static let cellId = "CellId"
    
    private var film: Film!
    private var people: [People?]!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            
            tableView.register(UINib(nibName: ActorCell.nibName, bundle: nil), forCellReuseIdentifier: FilmViewController.cellId)
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 140
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "actors"
        
        if let title = film.title {
            navigationItem.prompt = "\(title)"
        }
        
        getActorsFromFilm()
    }
    
    func getActorsFromFilm() {

        guard let urls = film.personsUrl?.urls else {
            self.showErrorMsg(title: "", msg: "there are no actors")
            return
        }
        
        _ = DownloadManager<People>(urls: urls, delegate: self)
    }
}

extension FilmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmViewController.cellId, for: indexPath) as! ActorCell
        
        let actor = people[indexPath.row]
        cell.configure(withName: actor?.name, gender: actor?.gender, height: actor?.height)
        
        return cell
    }
}

extension FilmViewController: DownloadManagerDelegate {
    
    func downloadFinished<T>(object: T, at index: Int, userInfo: [String : Any]?) where T : Decodable {
        if let people = object as? People {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.beginUpdates()
            self.people[index] = people
            tableView.reloadRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}
