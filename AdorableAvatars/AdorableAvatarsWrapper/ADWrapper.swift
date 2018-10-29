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
        let typesDelegate = self.delegate as? ADTypesDelegate
        
        guard let url = URL.init(string: "https://api.adorable.io/avatars/list") else {
            typesDelegate?.avatarTypesLoadDidFail(wrapper: self)
            return
        }
        
        var request = URLRequest.init(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    typesDelegate?.avatarTypesLoadDidFail(wrapper: self)
                }
                return
            }
            guard let validData = data else{
                DispatchQueue.main.async {
                    typesDelegate?.avatarTypesLoadDidFail(wrapper: self)
                }
                return
            }
            
            let decoder = JSONDecoder.init()
            do{
                let face = try decoder.decode(ADFaceComponents.self, from: validData)
                self.components = face
                DispatchQueue.main.async {
                    typesDelegate?.didLoadAvatarTypes(wrapper: self)
                }
            } catch {
                DispatchQueue.main.async {
                    typesDelegate?.avatarTypesLoadDidFail(wrapper: self)
                }
            }
        }.resume()
    }
    
    public func randomAvatar(withBase base: Int) {
        let randomAvatarDelegate = self.delegate as? ADRandomAvatarDelegate
        
        guard let url = URL.init(string: "https://api.adorable.io/avatars/\(base)") else {
            randomAvatarDelegate?.randomAvatarDidFail(wrapper: self, forNumber: base)
            return
        }
        
        var request = URLRequest.init(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.downloadTask(with: request) { (location, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    randomAvatarDelegate?.randomAvatarDidFail(wrapper: self, forNumber: base)
                }
                return
            }
            guard let location = location else {
                DispatchQueue.main.async {
                    randomAvatarDelegate?.randomAvatarDidFail(wrapper: self, forNumber: base)
                }
                return
            }
            do {
                if let image = try UIImage.init(url: location){
                    DispatchQueue.main.async {
                        randomAvatarDelegate?.didLoadRandomAvatar(wrapper: self, forNumber: base, image: image, inPath: location)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    randomAvatarDelegate?.randomAvatarDidFail(wrapper: self, forNumber: base)
                }
                return
            }
        }.resume()
    }
    
    public func getImage(for avatar: ADAvatar) {
        let avatarDelegate = self.delegate as? ADAvatarDelegate
        
        guard let url = avatar.url else {
            avatarDelegate?.avatarLoadDidFail(wrapper: self, for: avatar)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString)  {
            avatarDelegate?.didLoadAvatarImage(wrapper: self, image: cachedImage)
        }
        
        var request = URLRequest.init(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.downloadTask(with: request) { (location, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    avatarDelegate?.avatarLoadDidFail(wrapper: self, for: avatar)
                }
                return
            }
            guard let location = location else {
                DispatchQueue.main.async {
                    avatarDelegate?.avatarLoadDidFail(wrapper: self, for: avatar)
                }
                return
            }
            do {
                if let image = try UIImage.init(url: location){
                    DispatchQueue.main.async {
                        self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        avatarDelegate?.didLoadAvatarImage(wrapper: self, image: image)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    avatarDelegate?.avatarLoadDidFail(wrapper: self, for: avatar)
                }
                return
            }
        }.resume()
    }
}
