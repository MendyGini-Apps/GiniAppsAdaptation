//
//  HTTPRequest.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 21/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import Foundation

class HTTPRequest {
    private let baseUrl = "https://swapi.co/api/"
    private let url: URL
    
    init?(path: String) {
        guard let url = URL(string: baseUrl+path) else {return nil}
        self.url = url
    }
    
    func fetchResult(completion: @escaping (_ data: Data?, _ error: Error?)->Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
        
            guard let data = data else {
                return
            }
            
            completion(data, nil)
            
        }.resume()
        
        
    }
}
