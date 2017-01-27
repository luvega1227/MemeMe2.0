//
//  MemeDetailVC.swift
//  MemeMe2.0
//
//  Created by Luis Vega on 1/24/17.
//  Copyright © 2017 Vega. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    
    //MARK: - Properties & Outles
    
    
    var meme: Meme!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    // MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // configure Navigation Item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(MemeDetailVC.startMemeEditor))
        
        self.tabBarController?.tabBar.isHidden = true
        
        detailImageView!.image = meme.memeImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func startMemeEditor() {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        
        self.present(memeEditorVC, animated: true, completion: nil)
        
        memeEditorVC.topText.text = meme.topText
        memeEditorVC.bottomText.text = meme.bottomText
        memeEditorVC.memeImage.image = meme.backgroundImage
        memeEditorVC.isFromOtherVC = true
    }
    
}
