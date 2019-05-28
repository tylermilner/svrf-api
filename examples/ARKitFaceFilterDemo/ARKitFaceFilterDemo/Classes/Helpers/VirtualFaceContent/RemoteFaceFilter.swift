//
//  RemoteFaceFilter.swift
//  ARKitFaceFilterDemo
//
//  Created by Artem Titoulenko on 9/24/18.
//  Copyright © 2018 SVRF. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import SvrfSDK

// Protocol to notify the view controller about something
protocol RemoteFaceFilterDelegate {
    
    // The function that notifies the view controller that faceFilter loaded.
    func faceFilterLoaded()
}

class RemoteFaceFilter: SCNNode {
    
    // Delegate that realises RemoteFaceFilterDelegate protocol's functions
    var delegate: RemoteFaceFilterDelegate?
    var currentRequest: URLSessionDataTask?
    
    // faceFilter declaration
    private var faceFilter: SCNNode?
    
    // MTLDevice declaration
    private var device: MTLDevice?
    
    func loadFaceFilter(media: SvrfMedia) -> Void {
        
        if let currentRequest = currentRequest {
            currentRequest.cancel()
        }

        // Generate a face filter SCNNode from a Media
        currentRequest = SvrfSDK.generateNode(
            for: media,
            onSuccess: { faceFilter in
                // Remove any existing face filter from the SCNScene
                self.resetFaceFilters()
                // Set new face filter
                self.faceFilter = faceFilter
                
                // Put code into main async thread
                DispatchQueue.main.async {
                    // Add the face filter as a child node
                    if let head = self.faceFilter {
                        self.addChildNode(head)
                    }
                    
                    // Notify the view controller that faceFilter loaded
                    self.delegate?.faceFilterLoaded()
                }
        }, onFailure: { error in
            print("Error: \(error.svrfDescription ?? "")")
        })
    }
    
    // Function that deletes all childNodes from the self.faceFilter
    func resetFaceFilters() {
        
        // Unwrapping self.faceFilter
        if let head = self.faceFilter {
            
            // Remove all childNodes from the self.faceFilter
            for child in head.childNodes {
                child.removeFromParentNode()
            }
        }
    }
    
    // BlendShapeAnimation
    var blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber] = [:] {
        didSet {
            
            // Set blends shapes for face filter
            if let faceFilter = faceFilter {
                SvrfSDK.setBlendShapes(blendShapes: blendShapes, for: faceFilter)
            }
        }
    }
}

// Extension that realises VirtualFaceContent protocol's functions
extension RemoteFaceFilter: VirtualFaceContent {
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor, andMTLDevice device: MTLDevice ) {
        
        // Set a MTLDevice
        self.device = device
        
        // Set blendshapes
        blendShapes = faceAnchor.blendShapes
    }
}
