//
//  ViewController.swift
//  camera_test
//
//  Created by 岸田　崇志 on 2017/03/01.
//  Copyright © 2017年 takish.net. All rights reserved.
//

import UIKit
import AWSS3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func launchCamera(_ sender: UIBarButtonItem) {
        let camera = UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(camera) {
            let picker = UIImagePickerController()
            picker.sourceType = camera
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = image
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.dismiss(animated: true)
    }
    
    
    @IBAction func openAlbum(_ sender: Any) {
        let camera = UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(camera) {
            let picker = UIImagePickerController()
            picker.sourceType = camera
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func UploadS3(_ sender: Any) {
        print("Upload")
 
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let text = "Upload File."
        let fileName = "test.txt"
        let filePath = "\(docDir)/\(fileName)"
        print (filePath)
        try! text.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        
        let transferManager = AWSS3TransferManager.default()
  
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = "magiccanvas"
        uploadRequest?.key = "sample.txt"
        uploadRequest?.body = NSURL(string: "file://\(filePath)") as! URL
        uploadRequest?.acl = .publicRead
        uploadRequest?.contentType = "text/plain"
    
 
        transferManager.upload(uploadRequest!).continueWith { (task: AWSTask) -> AnyObject? in
            if task.error == nil && task.description == nil {
                print("success")
            } else {
                print("fail")
            }
            return nil
        }
    }
    
    @IBAction func NextButton(_ sender: Any) {

        
        performSegue(withIdentifier: "pushView",sender: nil)

    }

}

