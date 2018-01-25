//
//  Film.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 23/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import Foundation

struct Film: Decodable {
    let title: String?
    let description: String?
    let director: String?
    let producer: String?
    let personsUrl: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case director
        case producer
        case description = "opening_crawl"
        case personsUrl = "characters"
    }
}
