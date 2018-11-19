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
import SvrfGLTFSceneKit
import SvrfSDK

enum ChildNode: String {
    case Head = "Head"
    case Occluder = "Occluder"
}

class RemoteFaceFilter: SCNNode, VirtualFaceContent {
    
    private var head: SCNNode?
    private var device: MTLDevice?
    
    func loadFaceFilter(_ glbModelUrl: URL) -> Void {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            
            if let device = self.device {
                self.head = SvrfSDK.getHead(with: device, glbModelUrl: glbModelUrl)
                
                if let head = self.head {
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
            head?.enumerateHierarchy({ (node, _) in
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
