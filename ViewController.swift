//
//  ViewController.swift
//  HTN'19
//
//  Created by Pavitra Kurseja on 2019-09-14.
//  Copyright © 2019 Pavitra Kurseja. All rights reserved.
//

import UIKit
import Vision

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
    // Callback function for what happens in your main view
    // controller after the photo library view controller returns
    // after you picked an image.
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("A")
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("B")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit

            let scaledHeight = view.frame.width / image.size.width * image.size.height

            imageView.frame = CGRect(x: 0, y: 250, width: view.frame.width, height: scaledHeight)
            imageView.backgroundColor = .white

            view.addSubview(imageView)

            let request = VNDetectFaceRectanglesRequest { (req, err) in

                if let err = err {
                    print("Failed to detect faces:", err)
                    return
                }

                req.results?.forEach({ (res) in

                    DispatchQueue.main.async {
                        guard let faceObservation = res as? VNFaceObservation else { return }

                        let x = self.view.frame.width * faceObservation.boundingBox.origin.x

                        let height = scaledHeight * faceObservation.boundingBox.height

                        let y = 250 + scaledHeight * (1 -  faceObservation.boundingBox.origin.y) - height

                        let width = self.view.frame.width * faceObservation.boundingBox.width


                        let redView = UIView()
                        redView.backgroundColor = .red
                        redView.alpha = 0.4
                        redView.frame = CGRect(x: x, y: y, width: width, height: height)
                        self.view.addSubview(redView)

                        print(faceObservation.boundingBox)
                    }
                })
            }

            guard let cgImage = image.cgImage else { return }

            DispatchQueue.global(qos: .background).async {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    try handler.perform([request])
                } catch let reqErr {
                    print("Failed to perform request:", reqErr)
                }
            }
        }
    }
}
