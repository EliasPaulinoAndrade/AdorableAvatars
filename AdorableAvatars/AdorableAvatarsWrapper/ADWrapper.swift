//
//  AdorableAvatarsWrapper.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit
import Foundation

class ADWrapper {
    
    public var components: ADFaceComponents?
    public var delegate: ADDelegate?

    private var imageCache: NSCache<NSString, UIImage> = NSCache.init()
    
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.init()
        return URLSession.init(configuration: configuration)
    }()
    
    public func findTypes() {
        guard let url = URL.init(string: "https://api.adorable.io/avatars/list") else {
            delegate?.avatarTypesLoadDidFail(wrapper: self)
            return
        }
        
        var request = URLRequest.init(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    self.delegate?.avatarTypesLoadDidFail(wrapper: self)
                }
                return
            }
            guard let validData = data else{
                DispatchQueue.main.async {
                    self.delegate?.avatarTypesLoadDidFail(wrapper: self)
                }
                return
            }
            
            let decoder = JSONDecoder.init()
            do{
                let face = try decoder.decode(ADFaceComponents.self, from: validData)
                self.components = face
                DispatchQueue.main.async {
                    self.delegate?.didLoadAvatarTypes(wrapper: self)
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.avatarTypesLoadDidFail(wrapper: self)
                }
            }
        }.resume()
    }
    
    public func getImage(for avatar: ADAvatar) {
        guard let url = avatar.url else {
            delegate?.avatarLoadDidFail(wrapper: self, for: avatar)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString)  {
            
            self.delegate?.didLoadAvatarImage(wrapper: self, image: cachedImage)
        }
        
        var request = URLRequest.init(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.downloadTask(with: request) { (location, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    self.delegate?.avatarLoadDidFail(wrapper: self, for: avatar)
                }
                return
            }
            guard let location = location else {
                DispatchQueue.main.async {
                    self.delegate?.avatarLoadDidFail(wrapper: self, for: avatar)
                }
                return
            }
            do {
                let data = try Data.init(contentsOf: location)
                if let image = UIImage.init(data: data){
                    DispatchQueue.main.async {
                        self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        self.delegate?.didLoadAvatarImage(wrapper: self, image: image)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.avatarLoadDidFail(wrapper: self, for: avatar)
                }
                return
            }
            
        }.resume()
    }
}
