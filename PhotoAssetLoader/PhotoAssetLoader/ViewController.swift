//
//  ViewController.swift
//  PhotoAssetLoader
//
//  Created by Steven Suranie on 5/22/18.
//  Copyright © 2018 Steven Suranie. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnAccessLibrary: UIButton!
    @IBOutlet weak var btnShowImages: UIButton!
    @IBOutlet weak var cImages: UICollectionView!
    
    var arrImageIdentifiers = [String]()
    var arrImageViews = [UIImageView]()
    let imagePicker = UIImagePickerController()
    //fileprivate let reuseIdentifier = "imageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        cImages.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")

    }
    
    @IBAction func accessLibrary(_ sender: Any) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        
        if (status == PHAuthorizationStatus.denied || status == PHAuthorizationStatus.notDetermined) {
            
            
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.showLibrary()
                } else {
                    
                    let myAlert = UIAlertController(title: "Photo Library Access Denied", message: "Photo Asset Loader needs access to your photo library. Without it you will not be able to access any of your images. Please go into your app privacy settings and allow access.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    myAlert.addAction(okAction)
                    
                    self.present(myAlert, animated:true, completion:nil)
                    
                }
            })
            
            
        } else if status == PHAuthorizationStatus.authorized {
            showLibrary()
        }
    }
    
    func showLibrary() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if picker.sourceType == .photoLibrary {
            
            if let thisAsset:PHAsset = info[UIImagePickerControllerPHAsset] as? PHAsset {
                self.arrImageIdentifiers.append(thisAsset.localIdentifier)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func showImages(_ sender: Any) {

        if arrImageIdentifiers.count > 0 {
            
            arrImageViews.removeAll()
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            
            let results = PHAsset.fetchAssets(withLocalIdentifiers: arrImageIdentifiers, options: options)
            let manager = PHImageManager.default()
            
            results.enumerateObjects { (thisAsset, _, _) in
                manager.requestImage(for: thisAsset, targetSize: CGSize(width: 80.0, height: 80.0), contentMode: .aspectFit, options: nil, resultHandler: {(thisImage, _) in
                    self.arrImageViews.append(UIImageView(image: thisImage))
                })
            }
            
            self.cImages.reloadData()
        
        } else {
            
            let myAlert = UIAlertController(title: "No Images To Display", message: "There are no images to display. Select images from your photo library to display them.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            myAlert.addAction(okAction)
            
            self.present(myAlert, animated:true, completion:nil)
        }
        
        
    }
    
    //MARK: - Collection View Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImageViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell",
                                                      for: indexPath)
        
        cell.backgroundColor = UIColor.clear
        
        let ivThisImage = arrImageViews[indexPath.row]
        var ivFrame = ivThisImage.frame
        ivFrame.origin.x = 5.0
        ivFrame.origin.y = 5.0
        ivThisImage.frame = ivFrame
        
        cell.addSubview(ivThisImage)
        
        
        return cell
    }
    
    //testing the git stuff

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

