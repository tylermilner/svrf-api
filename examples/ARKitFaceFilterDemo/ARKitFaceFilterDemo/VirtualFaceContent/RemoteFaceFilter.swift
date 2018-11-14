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
import GLTFSceneKit

enum ChildNode: String {
    case Head = "Head"
    case Occluder = "Occluder"
}

class RemoteFaceFilter: SCNNode, VirtualFaceContent {
    
    private var head: SCNNode?
    private var device: MTLDevice?
    
    init(fromUrl url: String) {
        super.init()
        self.loadFaceFilter(URL(string: url)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func loadFaceFilter(_ glbModelUrl: URL) -> Void {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            do {
                // Try loading the glb model from a remote url
                let modelSource = GLTFSceneSource(url: glbModelUrl)
                let node = try modelSource.scene().rootNode
                
                self.head = SCNNode()
                
                if let occluderNode = node.childNode(withName: ChildNode.Occluder.rawValue, recursively: true) {
                    
                    self.head?.addChildNode(occluderNode)
                    
                    let faceGeometry = ARSCNFaceGeometry(device: self.device!)
                    self.head?.geometry = faceGeometry
                    self.head?.geometry?.firstMaterial?.colorBufferWriteMask = []
                    self.head?.renderingOrder = -1
                }
                
                if let headNode = node.childNode(withName: ChildNode.Head.rawValue, recursively: true) {
                    
                    self.head?.addChildNode(headNode)
                }
                
                // Normalize morphs
                self.head?.morpher?.calculationMode = SCNMorpherCalculationMode.normalized
                
                // Add the Face Filter into the current scene
                self.addChildNode(self.head!)
            } catch {
                print("Error creating scene: \(error.localizedDescription)")
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
