//
//  ViewController.swift
//  HTN'19
//
//  Created by Pavitra Kurseja on 2019-09-14.
//  Copyright © 2019 Pavitra Kurseja. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {

    @IBOutlet weak var myButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary //.camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func openCamera(_ sender: Any) {
        photoLibrary()
    }

//    func launchcamera(press:UILongPressGestureRecognizer)
//    {
//        if press.state = .began
//        { }
//    }
    

}

