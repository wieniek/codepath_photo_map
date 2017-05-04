//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,LocationsViewControllerDelegate, MKMapViewDelegate {

  @IBOutlet weak var mapview: MKMapView!
  
  var selectedImage: UIImage?
  var photoAnnotation: PhotoAnnotation?
  var resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
  
  
  
  func resizeImage(image: UIImage) -> UIImage? {
    
    resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
    resizeRenderImageView.layer.borderWidth = 3
    resizeRenderImageView.contentMode = .scaleAspectFit
    resizeRenderImageView.image = image
    
    UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
    resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    var thumbnail = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return thumbnail
    
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

      mapview.delegate = self
      
      let sfregion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(37.783333, -122.416667), span: MKCoordinateSpanMake(0.1, 0.1))
      
      mapview.setRegion(sfregion, animated: false)
      
    }

  
  @IBAction func cameraButtonTapped(_ sender: UIButton) {
    
    let viewController = UIImagePickerController()
    viewController.delegate = self
    viewController.allowsEditing = true
    viewController.sourceType = UIImagePickerControllerSourceType.photoLibrary
    self.present(viewController, animated: true, completion: nil)
    
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
    
    selectedImage = originalImage
    photoAnnotation?.photo = selectedImage
    
    dismiss(animated: true) { 
      self.performSegue(withIdentifier: "tagSegue", sender: self)
      
    }
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
  func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
    
    navigationController?.popToViewController(self, animated: true)
    print("called with lat and lng")
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
    annotation.title = "Sample picture"
    mapview.addAnnotation(annotation)
    
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseId = "myAnnotationView"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      annotationView?.canShowCallout = true
      annotationView?.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
    
    let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
    
    annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
  
    
    //imageView.image = UIImage(named: "camera")
    
    let resizedImage = resizeImage(image: selectedImage!)
    imageView.image = resizedImage
    return annotationView
    
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    self.performSegue(withIdentifier: "fullImageSegue", sender: self)
    
  }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if segue.destination is LocationsViewController {
        
        let locationsViewController = segue.destination as! LocationsViewController
        locationsViewController.delegate = self
        
        
      }
      
    }
    

}
