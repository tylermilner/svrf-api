//
//  ImageDownloader.swift
//  ARKitFaceFilterDemo
//
//  Created by Andrei Evstratenko on 09/01/2019.
//  Copyright © 2019 SVRF. All rights reserved.
//

import UIKit

class ImageDownloader {
    
    static func imageFromServerURL(_ URLString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url,
                                       completionHandler: { (data, _, error) in
                                        
                                        if error != nil {
                                            print("Error loading image: \(error?.localizedDescription ?? "")")
                                            DispatchQueue.main.async {
                                                completion(nil)
                                            }
                                            return
                                        }
                                        DispatchQueue.main.async {
                                            if let data = data {
                                                if let downloadedImage = UIImage(data: data) {
                                                    completion(downloadedImage)
                                                }
                                            }
                                        }
            }).resume()
        }
    }
}

