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
    
    public func combination(at: Int, withColor color: UIColor) -> ADAvatar? {
        if let eye = components?.eyesNumbers.first, let nose = components?.noseNumbers.first, let month = components?.mouthsNumbers.first {
            return ADAvatar.init(withEye: eye, withNose: nose, withMonth: month, andColor: color)
        }
        return nil
    }
    
    public func findTypes() {
        let typesDelegate = self.delegate as? ADTypesDelegate
        
        guard let url = URL.init(string: "https://api.adorable.io/avatars/list") else {
            typesDelegate?.avatarTypesLoadDidFail(wrapper: self)
            return
        }
        
        self.getData(withURL: url) { (sucess, data) in
            if sucess, let validData = data {
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
            }
        }
    }
    
    private func getImage(withURL url: URL, completion: @escaping (_ sucess: Bool, _ image: UIImage?) -> ()) {
        if let cachedImage: UIImage = CacheCenter.shared.get(withKey: url.absoluteString) {
            completion(true, cachedImage)
        }
        
        self.getFile(withURL: url) { (sucess, resultURL) in
            if sucess, let validUrl = resultURL {
                do {
                    if let image = try UIImage.init(url: validUrl){
                        DispatchQueue.main.async {
                            CacheCenter.shared.add(image: image, withKey: url.absoluteString)
                            completion(true, image)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                    return
                }
            } else {
                completion(false, nil)
            }
        }
    }
    
    private func getFile(withURL url: URL, completion: @escaping (_ sucess: Bool, _ data: URL?) -> ()) {
        
        var request = URLRequest.init(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.downloadTask(with: request) { (location, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            guard let location = location else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            
            completion(true, location)
        }.resume()
    }
    
    private func getData(withURL url: URL, completion: @escaping (_ sucess: Bool, _ data: Data?) -> ()) {
        var request = URLRequest.init(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            guard let validData = data else{
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            completion(true, validData)
        }.resume()
    }
    
    public func getAvatarImage(for avatar: ADAvatar) {
        let avatarDelegate = self.delegate as? ADAvatarDelegate
        
        guard let url = avatar.url else {
            avatarDelegate?.avatarLoadDidFail(wrapper: self, for: avatar)
            return
        }
    
        self.getImage(withURL: url) { (sucess, image) in
            if sucess, let avatarImage = image {
                avatarDelegate?.didLoadAvatarImage(wrapper: self, image: avatarImage)
            } else {
                avatarDelegate?.avatarLoadDidFail(wrapper: self, for: avatar)
            }
        }
    }
    
    public func randomAvatar(withBase base: Int) {
        let randomAvatarDelegate = self.delegate as? ADRandomAvatarDelegate
        
        guard let url = URL.init(string: "https://api.adorable.io/avatars/\(base)") else {
            randomAvatarDelegate?.randomAvatarDidFail(wrapper: self, forNumber: base)
            return
        }
        
        self.getImage(withURL: url) { (sucess, image) in
            if sucess, let randomAvatarImage = image {
                randomAvatarDelegate?.didLoadRandomAvatar(wrapper: self, forNumber: base, image: randomAvatarImage, inPath: url)
            } else {
                randomAvatarDelegate?.randomAvatarDidFail(wrapper: self, forNumber: base)
            }
        }
    }
}
