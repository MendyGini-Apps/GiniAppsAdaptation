//
//  People.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 21/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

struct People: Codable {
    let name: String?
    let height: String?
    let gender: String?
    let mass: String?
    let filmsStr: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case height
        case gender
        case mass
        case filmsStr = "films"
    }
}

struct PeopleResult: Codable {
    let results: [People]?
    let count: Int?
}
