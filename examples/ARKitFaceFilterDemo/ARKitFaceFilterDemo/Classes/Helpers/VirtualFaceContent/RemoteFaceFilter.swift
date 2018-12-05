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

protocol RemoteFaceFilterDelegate {
    func faceFilterLoaded()
}

class RemoteFaceFilter: SCNNode, VirtualFaceContent {
    
    var delegate: RemoteFaceFilterDelegate?
    
    private var faceFilter: SCNNode?
    private var device: MTLDevice?
    
    func loadFaceFilter(media: SvrfMedia) -> Void {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            if let device = self.device {
                self.faceFilter = SvrfSDK.getFaceFilter(with: device, media: media)
                
                if let head = self.faceFilter {
                    self.addChildNode(head)
                }
            }
            
            DispatchQueue.main.async {
                self.delegate?.faceFilterLoaded()
            }
        }
    }
    
    func resetFaceFilters() {
        if let head = self.faceFilter {
            for child in head.childNodes {
                child.removeFromParentNode()
            }
        }
    }
    
    /// - Tag: BlendShapeAnimation
    var blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber] = [:] {
        didSet {
            // each child node may have blend shape targets so we enumerate over all of them to make sure
            // that each blend target is expressed completely
            faceFilter?.enumerateHierarchy({ (node, _) in
                if node.morpher?.targets != nil {
                    SvrfSDK.setBlendShapes(blendShapes: blendShapes, for: node)
                }
            })
        }
    }
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor, andMTLDevice device: MTLDevice ) {
        self.device = device
        blendShapes = faceAnchor.blendShapes
    }
}
