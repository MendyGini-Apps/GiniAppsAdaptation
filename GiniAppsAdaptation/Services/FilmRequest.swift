//
//  FilmRequest.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 23/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import Foundation

class FilmRequest {
    
    class func getFilm(withUrl url: URL, completion: @escaping (Film?,Error?)->()) {
        HTTPRequest(url: url).fetchResult { (data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                completion(film, nil)
            } catch let err {
                completion(nil, err)
            }
            
            
            
        }
    }
    
}
