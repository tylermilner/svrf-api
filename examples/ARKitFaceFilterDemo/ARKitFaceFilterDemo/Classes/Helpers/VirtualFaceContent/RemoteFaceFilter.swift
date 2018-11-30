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
    
    // faceFilter declaration
    private var faceFilter: SCNNode?
    
    // MTLDevice declaration
    private var device: MTLDevice?
    
    func loadFaceFilter(media: SvrfMedia) -> Void {
        
        // Put code into background thread
        DispatchQueue.global(qos: .background).async { [unowned self] in
            
            // self.device unwrappin g
            if let device = self.device {
                
                // Get faceFilter with MTLDevice and Media
                self.faceFilter = SvrfSDK.getFaceFilter(with: device, media: media)

                // self.faceFilter unwrapping
                if let head = self.faceFilter {
                    
                    // Add childNode into self
                    self.addChildNode(head)
                }
            }
            
            // Put code into main async thread
            DispatchQueue.main.async {
                
                // Notify the view controller that faceFilter loaded
                self.delegate?.faceFilterLoaded()
            }
        }
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
            
            // Each child node may have blend shape targets so we enumerate over all of them to make sure
            // that each blend target is expressed completely
            
            faceFilter?.enumerateHierarchy({ (node, _) in
                for (blendShape, weight) in blendShapes {
                    let targetName = blendShape.rawValue
                    node.morpher?.setWeight(weight as! CGFloat, forTargetNamed: targetName)
                }
            })
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
