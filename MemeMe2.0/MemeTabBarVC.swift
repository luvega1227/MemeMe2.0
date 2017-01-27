//
//  MemeTabBarVC.swift
//  MemeMe2.0
//
//  Created by Luis Vega on 1/24/17.
//  Copyright © 2017 Vega. All rights reserved.
//

import UIKit

class MemeTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure Navigation Item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MemeCollectionVC.startMemeEditor))
        
    }
    
    func startMemeEditor() {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
}
