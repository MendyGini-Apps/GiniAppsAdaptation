//
//  DownloadManager.swift
//  GiniAppsAdaptation
//
//  Created by Menahem Barouk on 23/01/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import Foundation

protocol DownloadManagerDelegate: class {
    func downloadManager(_ manager: DownloadManager, FilmForIndex film: Film, atIndex index: Int)
}


class DownloadManager {
    private let urls: [URL]
    
    private weak var delegate: DownloadManagerDelegate!
    
    init(urls: [URL], delegate: DownloadManagerDelegate) {
        self.urls = urls
        self.delegate = delegate
        fetchResult()
    }
    
    private func fetchResult() {
        for url in urls {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data {
                    if let film = try? JSONDecoder().decode(Film.self, from: data) {
                        DispatchQueue.main.async {
                            
                            if let requestedUrl = response?.url,
                                let index = self.urls.index(of: requestedUrl) {
                                self.delegate.downloadManager(self, FilmForIndex: film, atIndex: index)
                            }
                        }
                    }
                }
            }).resume()
        }
        
    }
}
