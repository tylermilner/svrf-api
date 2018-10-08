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
    // Provide your SVRF API Key
    private let apiKey = "SVRF_API_KEY"
    private let type = [MediaType._3d]
    private var nextPageCursor: String?
    private var pageNum: Int?
    private var token: String?

    func request(closure: @escaping (String, @escaping ([Media]) -> Void) -> Void, id: String?, respondingWith: @escaping ([Media]) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            if self.token != nil {
                closure(id!, respondingWith)
                return
            }
            
            let body: Body = Body.init(apiKey: self.apiKey)

            AuthenticateAPI.authenticate(body: body) {response, error in
                if error != nil {
                    print("Error: \(error.debugDescription)")
                    fatalError("Could not authenticate")
                }

                self.token = response?.token
                closure(id!, respondingWith)
            }
        }
    }
    
    func getMediaById(id: String, respondingWith: @escaping ([Media]) -> Void) {
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
    
    func search(q: String, respondingWith: @escaping ([Media]) -> Void) {
        let category = MediaAPI.Category_search(rawValue: "Face Filters")
        var request: RequestBuilder<SearchMediaResponse> = MediaAPI.searchWithRequestBuilder(q: q, type: type, category: category, size: 10, pageNum: pageNum)
        request = request.addHeader(name: "x-app-token", value: self.token!)
        request.execute {response, error in
            if error != nil {
                print("Error: \(error.debugDescription)")
                fatalError("Error retrieving search query")
            }
            
            let res = response?.body?.media! ?? []
            print("search for '\(q)' returned \(res.count) results")
            respondingWith(res)
        }
    }
    
    func getTrending(id: String?, respondingWith: @escaping ([Media]) -> Void) {
        let category = MediaAPI.Category_getTrending(rawValue: "Face Filters")
        var request: RequestBuilder<TrendingResponse> = MediaAPI.getTrendingWithRequestBuilder(type: type, category: category, size: 10, nextPageCursor: nextPageCursor)
        request = request.addHeader(name: "x-app-token", value: self.token!)

        request.execute { (response: Response<TrendingResponse>?, error: Error?) in
            if error != nil {
                print("Error: \(error.debugDescription)")
                fatalError("Error retrieving search query")
            }
            let res = response?.body?.media! ?? []
            print("trending returned \(res.count) results")
            respondingWith(res)
        }
    }
}
