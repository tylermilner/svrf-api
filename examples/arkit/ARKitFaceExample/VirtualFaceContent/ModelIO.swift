//
//  BlendShapesMask.swift
//  ARKitFaceExample
//
//  Created by Brent Chow on 8/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import ModelIO
import SceneKit.ModelIO
import Alamofire

class ModelIO: SCNNode, VirtualFaceContent {
    var node: SCNNode?
    
    init(geometry: ARSCNFaceGeometry) {
        let urlArray = [
            "https://storage.googleapis.com/svrf-3d-assets/animated-cube/animated-cube.usdz",
        ]

        super.init()
        self.checkCompatibility(["abc", "dae", "drc", "fbx", "glb", "gltf", "obj", "ply", "stl", "usd", "usda", "usdc", "usdz"])
        self.downloadAssets(urlArray)
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
        let urlString = "file://\(filePath)"
        let asset = MDLAsset(url: URL(string: urlString)!)
        let object: MDLObject = asset.object(at: 0)

        self.node = SCNNode(mdlObject: object)
        self.addChildNode(self.node!)

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
                    // Add file to the scene
                    if filePath.lowercased().range(of: ".usdz") != nil {
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
                let targetName = "\(blendShape.rawValue)"
                self.node?.morpher?.setWeight(weight as! CGFloat, forTargetNamed: targetName)
            }
        }
    }
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        blendShapes = anchor.blendShapes
    }
}
