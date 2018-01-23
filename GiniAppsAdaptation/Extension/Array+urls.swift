//
//  Array+urls.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 23/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import Foundation

extension Array where Element == String {

    var urls: [URL]? {
        var urls = [URL]()
        for str in self {
            if let url = URL(string: str) {
                urls.append(url)
            } else {
                return nil
            }
        }
        
        return urls
    }
}
