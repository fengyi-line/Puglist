//
//  ImageHandler.swift
//  puglist
//
//  Created by ST20991 on 2019/09/08.
//  Copyright © 2019 fengyi. All rights reserved.
//

import Foundation
import UIKit

class ImageHandler: ImageFetcherDelegate {
    static let shared = ImageHandler()
    let fetcher: ImageFetcher
    
    var viewToURL = [UIImageView:URL]()
    var urlToViews = [URL:Set<UIImageView>]()
    
    init() {
        fetcher  = ImageFetcher()
        fetcher.delegate = self
    }
    
    func imageFetched(_ image: UIImage?, from url: URL) {
        DispatchQueue.main.async {
            self.urlToViews[url]?.forEach{ $0.image = image}
        }
    }
    
    func updateImageView(_ view: UIImageView, from url:URL, placeholder: UIImage?) {
        if let cachedImage = fetcher.image(from: url) {
            view.image = cachedImage
            return
        }
        
        view.image = placeholder
        
        DispatchQueue.main.async {
            self.viewToURL[view] = url
            self.urlToViews[url, default: Set<UIImageView>()].insert(view)
        }
        fetcher.fetch(url)
    }
}

protocol ImageFetcherDelegate: class {
    func imageFetched(_ image:UIImage?, from url:URL)
}

class ImageFetcher {
    weak var delegate: ImageFetcherDelegate?
    var cache = NSCache<NSString,UIImage>()
    var downloadingURLs = Set<URL>()
    let lock = NSRecursiveLock()
    
    func fetch(_ url:URL) {
        if let _ = image(from: url) {
            return
        }
        
        lock.lock()
        
        guard !self.downloadingURLs.contains(url) else {
            return
        }
        
        self.downloadingURLs.insert(url)
        
        lock.unlock()
        
        DispatchQueue.global().async {
            
            if let image = UIImage(data: (try? Data.init(contentsOf:url)) ?? Data()) {
                self.cache.setObject(image, forKey: url.nsstring)
                self.delegate?.imageFetched(image, from: url)
            } else {
                self.delegate?.imageFetched(nil, from: url)
            }
            
            self.lock.lock()
            self.downloadingURLs.remove(url)
            self.lock.unlock()
        }
    }
    
    func image(from url: URL) -> UIImage? {
        return cache.object(forKey: url.nsstring)
    }
}

extension URL {
    var nsstring: NSString {
        return self.absoluteString as NSString
    }
}
