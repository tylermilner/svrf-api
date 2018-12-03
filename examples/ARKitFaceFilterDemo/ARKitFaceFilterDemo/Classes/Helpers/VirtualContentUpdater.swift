/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An `ARSCNViewDelegate` which addes and updates the virtual face content in response to the ARFaceTracking session.
*/

import SceneKit
import ARKit

class VirtualContentUpdater: NSObject, ARSCNViewDelegate {

    // MARK: Properties
    
    /// The virtual content that should be displayed and updated.
    var virtualFaceNode: VirtualFaceNode? {
        didSet {
            setupFaceNodeContent()
        }
    }
    
    /**
     A reference to the node that was added by ARKit in `renderer(_:didAdd:for:)`.
     - Tag: FaceNode
     */
    private var faceNode: SCNNode?
    
    private let serialQueue = DispatchQueue(label: "com.svrf.ARKitFaceFilterDemo.serialSceneKitQueue")
    
    /// - Tag: FaceContentSetup
    private func setupFaceNodeContent() {
        guard let node = faceNode else { return }
        
        resetFaceNode()
        
        if let content = virtualFaceNode {
            node.addChildNode(content)
        }
    }
    
    private func resetFaceNode() {
        guard let node = faceNode else { return }
        
        // Remove all the current children.
        for child in node.childNodes {
            child.removeFromParentNode()
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    /// - Tag: ARNodeTracking
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Hold onto the `faceNode` so that the session does not need to be restarted when switching face filters.
        faceNode = node
        serialQueue.async {
            self.setupFaceNodeContent()
        }
    }
    
    /// - Tag: ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let device = renderer.device else { return }
        
        virtualFaceNode?.update(withFaceAnchor: faceAnchor, andMTLDevice: device)
    }
}
