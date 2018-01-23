//
//  FilmViewController.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 23/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class FilmViewController: UIViewController {
    
    class func instantiateFilmVC(withFilmUrlStr filmUrlStr: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filmVC = storyboard.instantiateViewController(withIdentifier: "FilmViewController") as! FilmViewController

        filmVC.filmUrlStr = filmUrlStr
        
        return filmVC
    }
    
    static let cellId = "CellId"
    
    private var filmUrlStr: String!
    private var people: [People?]! {
        didSet {
            tableView.reloadData()
        }
    }
    

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: FilmViewController.cellId)
        
        if let url = URL(string: filmUrlStr) {
            FilmRequest.getFilm(withUrl: url, completion: { (film, error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.showErrorMsg(title: "Error", msg: error.localizedDescription)
                        return
                    }
                }
                guard let urls = film?.actors?.urls else {
                    DispatchQueue.main.async {
                        self.showErrorMsg(title: "", msg: "data not received")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.people = [People?](repeating: nil, count:urls.count)
                }
                
                _ = DownloadManager<People>(urls: urls, delegate: self)
                
            })
        }
        
        
    }
}

extension FilmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmViewController.cellId, for: indexPath)
        cell.textLabel?.text = people[indexPath.row]?.name
        return cell
    }
}

extension FilmViewController: DownloadManagerDelegate {
    
    func downloadFinished<T>(object: T, at index: Int) where T : Decodable {
        if let people = object as? People {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.beginUpdates()
            self.people[index] = people
            tableView.reloadRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}
