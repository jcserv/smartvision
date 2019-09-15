//
//  ViewController.swift
//  FaceRecognition
//
//  Created by Brian Voong on 7/7/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {

    @IBOutlet weak var myButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "sample2") else { return }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        imageView.backgroundColor = .blue
        
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNDetectedObjectObservation else { return }
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    
                    let height = scaledHeight * faceObservation.boundingBox.height
                    
                    let y = scaledHeight * (1 -  faceObservation.boundingBox.origin.y) - height
                    
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redView)
                    
                    print(faceObservation.boundingBox)
                    speak("hello")

                    let recognized_faces = readJSONFromFile("./persons.json")

                    for person in recognized_faces {
                        if (person != null && person.width == width && person.height == height) {
                            speak(person.label)
                        }   
                    }

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
    

    func speak(message: String) {
        var speechUtterance: AVSpeechUtterance = AVSpeechUtterance(message)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speakUtterance(speechUtterance)
    }

    func readJSONFromFile(fileName: String) -> Any? {
      var json: Any?
      if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
          do {
              let fileUrl = URL(fileURLWithPath: path)
              // Getting data from JSON file using the file URL
              let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
              json = try? JSONSerialization.jsonObject(with: data)
          } catch {
              return
          }
      }
      return json
  }
}










