//
//  GLTFModelIO.swift
//  ARKitFaceExample
//
//  Created by Brent Chow on 9/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import ModelIO
import SceneKit.ModelIO
import Alamofire
import GLTFSceneKit

class GLTFModelIO: SCNNode, VirtualFaceContent {
    var node: SCNNode?
    
    init(geometry: ARSCNFaceGeometry) {
        let urlArray = [
            "https://storage.googleapis.com/svrf-3d-assets/cap-monster/gltf/cap-monster.gltf",
            ]
        super.init()

        self.downloadAssets(urlArray)
        self.node = SCNNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    let destination: DownloadRequest.DownloadFileDestination = { _, response in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = response.suggestedFilename!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    func addSCNNode(_ filePath: String) -> Void {
        let scene: SCNScene?
        
        let urlString = "file://\(filePath)"

        do {
            let sceneSource = try GLTFSceneSource(named: urlString)
            scene = try sceneSource.scene()
        } catch {
            print("\(error.localizedDescription)")
            return
        }

        self.addChildNode(scene!)
        
        // scale obj
        self.scale = SCNVector3(0.001, 0.001, 0.001)
    }
    
    func checkCompatibility(_ extensions: [String]) -> Void{
        for ext in extensions {
            let isSupported: Bool = MDLAsset.canExportFileExtension(ext)
            print("\(ext) is supported: \(isSupported)")
        }
    }
    
    func downloadAssets(_ urlArray: [String]) -> Void {
        var urlArray = urlArray
        
        if let urlString = urlArray.popLast() {
            Alamofire.download(urlString, to: destination).response { response in
                if response.error == nil, let filePath = response.destinationURL?.path {
                    // Add obj to the scene
                    if filePath.lowercased().range(of: ".gltf") != nil {
                        self.addSCNNode(filePath)
                    }
                    
                    print("Completed download for: \(filePath)")
                    self.downloadAssets(urlArray)
                }
            }
        } else {
            print("downloaded all assets")
            
        }
    }
    
    // Map ARKit face tracking blend shapes to model's morph targets
    var blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber] = [:] {
        didSet {
            for (blendShape, weight) in blendShapes {
                // Maya appends `Mesh` to blend shape names when exporting to .DAE
                let targetName = "\(blendShape.rawValue)"
                if (targetName.range(of: "jaw") != nil) {
                    print("target: \(targetName): \(weight)")
                }
                self.node?.morpher?.setWeight(weight as! CGFloat, forTargetNamed: targetName)
            }
        }
    }
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        blendShapes = anchor.blendShapes
    }
}
