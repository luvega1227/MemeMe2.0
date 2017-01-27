//
//  MemeEditorVC.swift
//  MemeMe2.0
//
//  Created by Luis Vega on 1/23/17.
//  Copyright © 2017 Vega. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // MARK: - Outlets & Properties
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var topText: MemeTextField!
    @IBOutlet weak var bottomText: MemeTextField!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    let memeDelegate = MemeTextField()
    enum ToolBarButtonItem: Int{
        case camera = 0
        case album  = 1
    }
    
    //To control cancel button display with 'cancelButton.isEnabled = isFromOtherVC'
    //Disable cancel button by assigning 'isFromOtherVC' to false
    //Later, when it is used from other View Controller, enable cancel button by assigning it to true
    var isFromOtherVC = false
    
    //To hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: App Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup delegate for text views
        topText.delegate = self
        bottomText.delegate = self
        
        //Share button starts disabled
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Check if the camera exists
        cameraButton.isEnabled = MemeMeUtils.isCameraAvailable()
        
        shareButton.isEnabled = (memeImage.image != nil)
        
        cancelButton.isEnabled = isFromOtherVC
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    // MARK: Buttons Pressed
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
            MemeMeUtils.openCamera(sourceController: self, delegate: self)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let model = Meme(
            topText: topText.text!,
            bottomText: bottomText.text!,
            backgroundImage: memeImage.image!,
            memeImage: produceImage()
        )
        
        let activityViewController = UIActivityViewController(activityItems: [model.memeImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        memeImage.image = nil
        shareButton.isEnabled = false
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func albumButtonPressed(_ sender: Any) {
        MemeMeUtils.openImageGallery(sourceController: self, delegate: self)
    }
    
    
    // MARK: MemeMe Image
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = selectedImage
            shareButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func produceImage() -> UIImage! {
        toolBar.isHidden = true
        navBar.isHidden = true
        
        // Render view to an image
        let generatedImage = MemeMeUtils.renderScreenToImage(view: self.view)
        
        toolBar.isHidden = false
        navBar.isHidden = false
        
        return generatedImage
    }
    
    func save() {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, backgroundImage: memeImage.image!, memeImage: produceImage())
        
        //Append it to the MemesArray in the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    
    // MARK: Keyboard Notifications
    
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        //Only makes the UI to go up when edditing the bottom text
        if bottomText.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    // MARK: TextField Delegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //If the text field is in pristine state (i.e. still have the original value),
        //then we clear the text.
        if let memeTextField = textField as? MemeTextField {
            if memeTextField.isPristine {
                memeTextField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let memeTextField = textField as? MemeTextField {
            if memeTextField.text!.isEmpty {
                memeTextField.restorePristine()
            } else {
                memeTextField.isPristine = false
            }
        }
    }
}
