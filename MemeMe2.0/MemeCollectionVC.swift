//
//  MemeCollectionVC.swift
//  MemeMe2.0
//
//  Created by Luis Vega on 1/24/17.
//  Copyright © 2017 Vega. All rights reserved.
//

import UIKit

class MemeCollectionVC: UICollectionViewController {
    
    
    //MARk: - Properties
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    
    
    //MARK : Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure Navigation Item (+ sign)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MemeCollectionVC.startMemeEditor))
        
        // Set up a collection View Flow Layout
        // and, min(frame.width, frame.height) to adapte in both landscape and portrait
        let space:CGFloat = 3.0
        let dimension = (min(view.frame.size.width,view.frame.size.height) - (2*space))/3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Get memes data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Update Model
        //To make sure the Meme is synced to latest data model in appDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        //Update View
        //Reload Collection View with updated data model
        self.collectionView?.reloadData()
        
    }
    
    func startMemeEditor() {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        
        self.present(memeEditorVC, animated: true, completion: nil)
        memeEditorVC.isFromOtherVC = true
    }
  
    
    //MARK : Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        let meme = memes[indexPath.row]
        cell.memeImageCell?.image = meme.memeImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
