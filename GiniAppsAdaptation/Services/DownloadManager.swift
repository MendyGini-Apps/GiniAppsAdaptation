//
//  DownloadManager.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 23/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import Foundation

protocol DownloadManagerDelegate: class {
    func downloadFinished<T: Decodable>(object: T, at index: Int, userInfo: [String:Any]?)
}


class DownloadManager<T: Decodable> {
    
    let urls: [URL]
    let userInfo: [String:Any]?
    weak var delegate: DownloadManagerDelegate!
    
    init(urls: [URL], delegate: DownloadManagerDelegate, userInfo: [String:Any]? = nil) {
        self.urls = urls
        self.delegate = delegate
        self.userInfo = userInfo
        fetchResult()
    }
    
    private func fetchResult() {
        for url in urls {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data {
                    if let decodedObject = try? JSONDecoder().decode(T.self, from: data) {
                        DispatchQueue.main.async {
                            
                            if let requestedUrl = response?.url,
                                let index = self.urls.index(of: requestedUrl) {
                                self.delegate.downloadFinished(object: decodedObject, at: index, userInfo: self.userInfo)
                            }
                        }
                    }
                }
            }).resume()
        }
        
    }
}



