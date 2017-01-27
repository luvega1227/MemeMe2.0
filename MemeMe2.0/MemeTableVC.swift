//
//  MemeTableVC.swift
//  MemeMe2.0
//
//  Created by Luis Vega on 1/24/17.
//  Copyright © 2017 Vega. All rights reserved.
//

import UIKit

class MemeTableVC: UITableViewController{
    
    var memes: [Meme]!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure Navigation Item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MemeCollectionVC.startMemeEditor))
    }
    
    func startMemeEditor() {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        
        self.present(memeEditorVC, animated: true, completion: nil)
        memeEditorVC.isFromOtherVC = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Sync to Model, get memes data
        //Meme is synced to latest data model in appDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        //Reload Table View with updated data model
        //Thus, the TableViewCell will always be re-populated
        self.tableView?.reloadData()
    }

    
    //MARK : Table View Delegate

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        
        let meme = memes[indexPath.row]
        
        
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        
        //Create image Icon in tableViewCell
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byTruncatingMiddle
        
        let memeTextAttributtes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
            NSStrokeWidthAttributeName: -3.0,
            NSParagraphStyleAttributeName: style
            ] as [String : Any]
        
        let iconLength = min(view.frame.size.width,view.frame.size.height)/3.0
        let newSize = CGSize(width: iconLength, height: iconLength)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        meme.memeImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let top = CGRect(x: 0, y: 0, width: iconLength, height: 20)
        let bottom = CGRect(x: 0, y: iconLength-20, width: iconLength, height: 20)
        (meme.topText as NSString).draw(in: top , withAttributes: memeTextAttributtes)
        (meme.bottomText as NSString).draw(in: bottom, withAttributes: memeTextAttributtes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //Create image Icon in tableViewCell
        
        cell.imageView?.image = newImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // Remove data in current meme
            memes.remove(at: indexPath.row)
            
            // Remove data in appDelegate to sync it
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            
            // Update UI
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
