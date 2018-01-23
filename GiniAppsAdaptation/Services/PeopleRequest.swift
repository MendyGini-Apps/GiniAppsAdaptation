//
//  PeopleRequest.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 21/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import Foundation

class PeopleRequest {
    
    private let path = "people"
    
    func getPeople(completion: @escaping (_ people: [People]?, _ error: Error?) -> Void) {
        
        guard let request = HTTPRequest(path: path) else { return }
        
        request.fetchResult(completion: { (data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let api = try JSONDecoder().decode(PeopleResult.self, from: data)
                completion(api.results, nil)
            } catch let err {
                completion(nil, err)
            }
        })
        
    }
}
