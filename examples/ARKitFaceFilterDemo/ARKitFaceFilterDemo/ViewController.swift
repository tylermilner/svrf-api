//
//  ViewController.swift
//  ARKitFaceFilterDemo
//
//  Created by Artem Titoulenko on 9/24/18.
//  Copyright © 2018 SVRF. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SVRFClientSwift
import SvrfGLTFSceneKit
import SvrfSDK

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UISearchBarDelegate, UICollectionViewDelegate {

    // The scene view which will handle face tracking and applying Face Filters
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var searchBar: UISearchBar!
    
    // The search results view
    @IBOutlet weak var searchView: SearchViewController!
    
    // Reset button which will appear when a face filter is applied
    @IBOutlet weak var resetButton: UIButton!
    
    // Remove the face filter when the "Reset" button is pressed
    @IBAction func resetFaceFilter(_ sender: UIButton) {
        contentUpdater.resetFaceNode()
        resetButton.isHidden = true
    }

    
    // MARK: Properties
    
    // This will control which Face Filter is being used
    let contentUpdater = VirtualContentUpdater()
    
    // Create an activity indicator for when we are loading search results
    let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    // Text field saying no results were found
    let noResultsIndicator : UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 75))

    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = contentUpdater
        
        // automatically update lighting
        sceneView.automaticallyUpdatesLighting = true
        
        // Show statistics such as fps and timing information at the bottom
        sceneView.showsStatistics = true
        
        // This view controller handles search
        searchBar.delegate = self
        
        // Hide the search view initially
        searchView.isHidden = false
        
        // Init RemoteFaceFilter
        let remoteFaceFilter = RemoteFaceFilter()
        self.contentUpdater.virtualFaceNode = remoteFaceFilter
        
        // Set hook to create a new RemoteFaceFilter when a face filter is selected from the results
        searchView.selectedItemDidChange = { [unowned self] (_ media: Media) -> Void in
            if let glbUrl = media.files?.glb {
                // Set the current filter to be the selected Face Filter
                remoteFaceFilter.loadFaceFilter(URL(string: glbUrl)!)
                // Show the reset button
                self.resetButton.isHidden = false
            }
        }
        
        // Add the activity indicator in the middle of the search view
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = searchView.center
        activityIndicator.style = .whiteLarge
        view.addSubview(activityIndicator)
        
        // Create "no results" view
        noResultsIndicator.text = "No results found"
        noResultsIndicator.center = searchView.center
        noResultsIndicator.textColor = .white
        noResultsIndicator.alpha = 0
        view.addSubview(noResultsIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchView.isHidden = true
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    // Show the cancel button when the text is being edited
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Hide the search results when the search text is empty
        if searchText == "" {
            searchView.isHidden = true
            searchView.items = []
            searchView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            activityIndicator.startAnimating()

            SvrfSDK.search(query: query, type: [._3d], stereoscopicType: nil, category: nil, size: 10, pageNum: nil, onSuccess: { items in
                self.searchView.isHidden = false
                self.activityIndicator.stopAnimating()
                
                let faceFilters = items.filter({ (media : Media) -> Bool in
                    return media.files?.glb != nil
                })
                
                // Pass the search results to the search view
                self.searchView.items = faceFilters
                if faceFilters.count < 1 {
                    self.noResultsIndicator.alpha = 1
                    
                    // Show the "No results" view for a bit and then face it out
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (Timer) -> Void in
                        UIView.animate(withDuration: 0.4, animations: { () -> Void in
                            self.noResultsIndicator.alpha = 0
                        })
                    })
                    
                }
                
                // Tell the search view to reload
                self.searchView.reloadData()
            }) { error in
                
            }
        }

        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

class ContentCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ContentCell.self)
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UITextField!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.backgroundColor = .darkGray
            } else {
                imageView.backgroundColor = .lightGray
            }
        }
    }
}

class SearchViewController : UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    public var items: [Media] = []
    
    var selectedItem: Media?
    
    var selectedItemDidChange: (Media) -> Void = { _ in }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = self
        self.delegate = self
        self.isUserInteractionEnabled = true
        self.allowsSelection = true
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ContentCell else { return }
        
        // Animate alpha + slide to the left when the search results come in
        cell.alpha = 0
        cell.layer.transform = CATransform3DTranslate(CATransform3DMakeTranslation(10, 0, 0), 1, 1, 1)
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            cell.alpha = 1
            cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 1, 1, 1)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseIdentifier, for: indexPath) as? ContentCell else {
            fatalError("Expected `\(ContentCell.self)` type for reuseIdentifier \(ContentCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        
        // round the corners of the image view and the whole layer
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.layer.masksToBounds = true
        
        let content = items[indexPath.item]
        if let previewImage = content.files?.images?._720x720, let previewUrl = URL(string: previewImage) {
            do {
                cell.imageView?.image = try UIImage(data: Data(contentsOf: previewUrl))
            } catch {
                print("could not fetch preview image: \(error)")
                cell.imageView?.backgroundColor = .lightGray
            }
        }
        cell.title.text = content.title
        if let selectedItem = selectedItem {
            cell.isSelected = items[indexPath.item].title == selectedItem.title
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = items[indexPath.item]
        selectedItemDidChange(selectedItem!)
    }
}
