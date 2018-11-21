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

class RemoteFaceFilter: SCNNode, VirtualFaceContent {
    
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
        }
    }
    
    /// - Tag: BlendShapeAnimation
    var blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber] = [:] {
        didSet {
            // each child node may have blend shape targets so we enumerate over all of them to make sure
            // that each blend target is expressed completely
            faceFilter?.enumerateHierarchy({ (node, _) in
                for (blendShape, weight) in blendShapes {
                    let targetName = blendShape.rawValue
                    node.morpher?.setWeight(weight as! CGFloat, forTargetNamed: targetName)
                }
            })
        }
    }
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor, andMTLDevice device: MTLDevice ) {
        self.device = device
        blendShapes = faceAnchor.blendShapes
    }
}
