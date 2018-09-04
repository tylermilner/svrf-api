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

class BlendShapesModelIO: SCNNode, VirtualFaceContent {
    init(geometry: ARSCNFaceGeometry) {
        let urlArray = [
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/CarrotHead.obj",
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/1.jpg",
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/2.jpg",
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/3.jpg",
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/4.jpg",
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/ARM.jpg",
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/BODY.jpg",
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/CarrotHead.mtl",
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/EYE.jpg",
            "https://storage.googleapis.com/svrf-uploads/Test3DAssets/CarrotHeadObj/TONGUE.jpg",
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
        let node = SCNNode(mdlObject: object)
        
        self.addChildNode(node)

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
                    if filePath.lowercased().range(of: ".obj") != nil {
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
    
    func update(withFaceAnchor: ARFaceAnchor) {
        // blend shape stuff
    }
}
