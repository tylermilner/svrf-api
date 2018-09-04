/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An `SCNNode` subclass demonstrating how to configure overlay content.
*/

import ARKit
import SceneKit

class FaceMask: SCNNode, VirtualFaceContent {
    private var headNode: SCNNode?
    private var occlusionNode: SCNNode?

    /// - Tag: OcclusionMaterial
    init(geometry: ARSCNFaceGeometry, modelName: String, modelPath: String) {
        let modelNode: SCNNode = loadedContentForAsset(named: modelName, path: modelPath)

        headNode = modelNode.childNode(withName: "Head", recursively: true)
        occlusionNode = modelNode.childNode(withName: "Occluder", recursively: true)
        
        super.init()

        // Set morphers to `normalized`
        headNode?.morpher?.calculationMode = SCNMorpherCalculationMode.normalized
        occlusionNode?.morpher?.calculationMode = SCNMorpherCalculationMode.normalized

        /*
         Write depth but not color and render before other objects.
         This causes the geometry to occlude other SceneKit content
         while showing the camera view beneath, creating the illusion
         that real-world objects are obscuring virtual 3D objects.
         */
        occlusionNode?.geometry?.firstMaterial?.colorBufferWriteMask = []
        occlusionNode?.renderingOrder = -1

        addChildNode(modelNode)
        print("modelNode", modelNode.childNodes)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    // Map ARKit face tracking blend shapes to model's morph targets
    var blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber] = [:] {
        didSet {
            for (blendShape, weight) in blendShapes {
                // Maya appends `Mesh` to blend shape names when exporting to .DAE
                let targetName = "\(blendShape.rawValue)Mesh"
                headNode?.morpher?.setWeight(weight as! CGFloat, forTargetNamed: targetName)
                occlusionNode?.morpher?.setWeight(weight as! CGFloat, forTargetNamed: targetName)
            }
        }
    }

    func update(withFaceAnchor anchor: ARFaceAnchor) {
        blendShapes = anchor.blendShapes
    }
}
