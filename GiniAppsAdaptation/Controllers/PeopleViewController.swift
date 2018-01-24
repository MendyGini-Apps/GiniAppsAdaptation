//
//  PeopleViewController.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 21/01/2018.
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

class PeopleViewController: UIViewController {
    
    static let cellId = "CellId"
    static let headerId = "HeaderId"

    var sections: [Section] = [] {
        didSet {
            tableView.reloadData()
            tableView.isHidden = false
        }
    }
    
    var people: [People] = []
    var filmDict: [IndexPath:Film] = [:]
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.isHidden = true

        }
    }
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: FilmTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PeopleViewController.cellId)
        tableView.register(UINib(nibName: PeopleHeaderSection.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: PeopleViewController.headerId)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 140
        getPeople()
    }
    
    func getPeople() {
        PeopleRequest().getPeople { (people, error) in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                if let error = error {
                    self.showErrorMsg(title: "Error", msg: error.localizedDescription)
                    return
                }
                
                guard let people = people else {
                    self.showErrorMsg(title: "", msg: "data not received")
                    return
                }
                for person in people {
                    self.sections.append(Section(people: person))
                }
                self.people = people
                
            }
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].isCollapse {
            return 0
        }
        return sections[section].people.filmsStr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleViewController.cellId, for: indexPath) as! FilmTableViewCell

        cell.configure(whiteFilm: filmDict[indexPath])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PeopleViewController.headerId) as? PeopleHeaderSection else {
            return nil
        }
        header.collapseButton.tag = section
        header.collapseButton.addTarget(self, action: #selector(handleExpandClose(_:)), for: .touchUpInside)
        
        header.configure(withSection: sections[section])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePresentPerson(_:)))
        header.addGestureRecognizer(tapGesture)
        tapGesture.view?.tag = section
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let film = filmDict[indexPath] else { return }
        let nextVC = FilmViewController.instantiateFilmVC(withFilm: film)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    private func handlePresentPerson(_ gesture: UIGestureRecognizer) {
        if let section = gesture.view?.tag {
            let nextVC = PersonViewController.instantiatePersonVC(withPerson: sections[section].people)
            present(nextVC, animated: true)
        }
    }
    
    @objc
    private func handleExpandClose(_ button: UIButton) {
        let section = button.tag
        
        guard let films = people[section].filmsStr else {
            return
        }
        
        let header = tableView.headerView(forSection: section) as! PeopleHeaderSection
        
        let isCollapse = header.isCollapse
        header.isCollapse = !isCollapse
        sections[section].isCollapse = header.isCollapse
        
        var indexPaths = [IndexPath]()
        for row in films.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        tableView.beginUpdates()
        if isCollapse {
            tableView.insertRows(at: indexPaths, with: .fade)
            if !filmDictContains(indexPaths: indexPaths) {
                if let urls = films.urls {
                    _ = DownloadManager<Film>(urls: urls, delegate: self, userInfo: ["section":section])
                }
            }
            
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        tableView.endUpdates()
        
    }
    
    private func filmDictContains(indexPaths: [IndexPath]) -> Bool {
        for indexPath in indexPaths {
            if filmDict[indexPath] == nil {
                return false
            }
        }
        return true
    }
    
}

extension PeopleViewController: DownloadManagerDelegate {
    func downloadFinished<T>(object: T, at index: Int, userInfo: [String : Any]?) where T : Decodable {
        if let film = object as? Film, let section = userInfo?["section"] as? Int {
            let indexPath = IndexPath(row: index, section: section)
            filmDict[indexPath] = film
            if let indexPathsVisible = tableView.indexPathsForVisibleRows, indexPathsVisible.contains(indexPath) {
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
}
















