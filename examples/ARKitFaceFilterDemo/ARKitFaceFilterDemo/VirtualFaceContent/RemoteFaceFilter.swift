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

class RemoteFaceFilter: SCNNode, VirtualFaceContent {
    private var head: SCNNode?
    
    init(fromUrl url: String) {
        super.init()
        self.loadFaceFilter(URL(string: url)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func loadFaceFilter(_ glbModelUrl: URL) -> Void {
        DispatchQueue.global(qos: .background).async {
            do {
                // Try loading the glb model from a remote url
                let modelSource = GLTFSceneSource(url: glbModelUrl)
                let node = try modelSource.scene().rootNode
                
                // There will be a child node named "Head", which is the root node of the Face Filter
                if let head = node.childNode(withName: "Head", recursively: true) {
                    self.head = head
                    
                    // Normalize morphs
                    self.head?.morpher?.calculationMode = SCNMorpherCalculationMode.normalized
                    
                    // Add the Face Filter into the current scene
                    self.addChildNode(self.head!)
                    
                }
                
                // because our models don't have standardized extent limits yet
                let factor = 0.06
                self.scale = SCNVector3(factor, factor, factor)
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
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        blendShapes = faceAnchor.blendShapes
    }
}
