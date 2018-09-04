//
//  SvrfAPI.swift
//  ARKitFaceExample
//
//  Created by Brent Chow on 8/22/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import SVRFClientSwift
import Alamofire

class SvrfAPI {
    private let apiKey = "9653722f1e10d9394f0c109f1ed7d5e8"
    private let type = "3D"
    private let category = "Face Mask"

    private var nextPageCursor: String?
    private var pageNum: Int?
    private var token: String?

    func request(closure: @escaping (String) -> Void, id: String?) {
        print("authenticate")
        if token != nil {
            closure(id!)
            return
        }

        let body: Body = Body.init(apiKey: apiKey)

        AuthenticateAPI.authenticate(body: body) {response, error in
            if error != nil {
                print("Error: \(error.debugDescription)")
                fatalError("Could not authenticate")
            }

            self.token = response?.token
            closure(id!)
        }
    }
    
    func getMediaById(id: String) {
        var request: RequestBuilder<SingleMediaResponse> = MediaAPI.getByIdWithRequestBuilder(id: id)

        request = request.addHeader(name: "x-app-token", value: self.token!)
        request.execute {response, error in
            if error != nil {
                print("Error: \(error.debugDescription)")
                fatalError("Error retrieving media by ID")
            }
            
            print("media \(id)", response?.body?.media?.embedUrl as Any)
        }
    }
    
    func search(q: String) {
        var request: RequestBuilder<SearchMediaResponse> = MediaAPI.searchWithRequestBuilder(q: q, type: type, category: category, size: 10, pageNum: pageNum)
        request = request.addHeader(name: "x-app-token", value: self.token!)
        request.execute {response, error in
            if error != nil {
                print("Error: \(error.debugDescription)")
                fatalError("Error retrieving search query")
            }
            
            print("search for \(q) count", response?.body?.media?.count as Any)
        }
    }
    
    func getTrending() {
        var request: RequestBuilder<TrendingResponse> = MediaAPI.getTrendingWithRequestBuilder(type: type, category: category, size: 10, nextPageCursor: nextPageCursor)
        request = request.addHeader(name: "x-app-token", value: self.token!)

        request.execute { (response: Response<TrendingResponse>?, error: Error?) in
            if error != nil {
                print("Error: \(error.debugDescription)")
                fatalError("Error retrieving search query")
            }
            
            print("trending count", response?.body?.media?.count as Any)
        }
    }
}
