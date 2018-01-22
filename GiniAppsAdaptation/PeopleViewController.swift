//
//  PeopleViewController.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 21/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    static let cellId = "CellId"
    static let headerId = "HeaderId"

    var people: [People] = [] {
        didSet {
            tableView.reloadData()
            tableView.isHidden = false
        }
    }
    
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
        
        tableView.register(UINib(nibName: PeopleTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PeopleViewController.cellId)
        tableView.register(UINib(nibName: PeopleHeaderSection.nibName, bundle: nil), forCellReuseIdentifier: PeopleViewController.headerId)
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
                
                self.people = people
                
            }
        }
    }

    func showErrorMsg(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people[section].films?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleViewController.cellId, for: indexPath) as! PeopleTableViewCell
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(withIdentifier: PeopleViewController.headerId) as? PeopleHeaderSection else {
            return nil
        }
        
        let person = people[section]
        
        header.configure(withName: person.name, gender: person.gender, height: person.height)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose(_:)))
        header.addGestureRecognizer(tapGesture)
        
        return header
    }
    
    @objc func handleExpandClose(_ gesture: UITapGestureRecognizer) {
        
    }
    
}

















