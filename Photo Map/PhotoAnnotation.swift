//
//  PhotoAnnotation.swift
//  Photo Map
//
//  Created by Wieniek Sliwinski on 5/4/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
  
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var photo: UIImage!
  
  
}
