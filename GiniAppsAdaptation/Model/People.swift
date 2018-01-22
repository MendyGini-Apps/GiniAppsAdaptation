//
//  People.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 21/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

class People: Decodable {
    let name: String?
    let height: String?
    let gender: String?
    var films: [String]?
}

class Result: Decodable {
    let results: [People]?
    let count: Int?
}
