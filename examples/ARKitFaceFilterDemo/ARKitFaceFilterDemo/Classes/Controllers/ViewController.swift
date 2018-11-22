//
//  ViewController.swift
//  SVRFFrameworkSetup
//
//  Created by Andrei Evstratenko on 11/5/18.
//  Copyright © 2018 SVRF, Inc. All rights reserved.
//

import UIKit
import ARKit
import SvrfSDK

class ViewController: UIViewController {
    
    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchCollectionView: SearchCollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var noResultsLabel: UILabel!
    @IBOutlet private weak var resetButton: UIButton!
    
    private let contentUpdater = VirtualContentUpdater()
    private let remoteFaceFilter = RemoteFaceFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCollectionView.customDelegate = self
        
        sceneView.delegate = contentUpdater
        sceneView.automaticallyUpdatesLighting = true
        sceneView.showsStatistics = true
        
        remoteFaceFilter.delegate = self
        
        contentUpdater.virtualFaceNode = remoteFaceFilter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        contentUpdater.resetFaceNode()
        resetButton.isHidden = true
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchCollectionView.isHidden = true
        
        self.noResultsLabel.isHidden = true
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {

            searchCollectionView.isHidden = true

            searchCollectionView.setupWith(mediaArray: [])
            searchCollectionView.reloadData()
        }
        
        self.noResultsLabel.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        activityIndicator.startAnimating()
        
        searchBar.resignFirstResponder()
        
        guard let query = searchBar.text else {
            return
        }
        
        SvrfSDK.search(query: query, type: [._3d], stereoscopicType: nil, category: nil, size: nil, pageNum: nil, onSuccess: { mediaArray in
           
            self.activityIndicator.stopAnimating()
            
            self.searchCollectionView.setupWith(mediaArray: mediaArray)
            self.searchCollectionView.reloadData()
            
            self.searchCollectionView.isHidden = false
            
            if mediaArray.isEmpty {
                self.noResultsLabel.isHidden = false
            }
        }) { (error) in
            self.activityIndicator.stopAnimating()
        }
    }
}

extension ViewController: SearchCollectionViewDelegate {
   
    func mediaSelected(media: SvrfMedia) {
        
            activityIndicator.startAnimating()
            remoteFaceFilter.loadFaceFilter(media: media)
            resetButton.isHidden = false
    }
}

extension ViewController: RemoteFaceFilterDelegate {
    
    func faceFilterLoaded() {
        activityIndicator.stopAnimating()
    }
}
 
