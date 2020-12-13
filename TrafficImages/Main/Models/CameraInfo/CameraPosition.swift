//
//  CameraPosition.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import UIKit
import MapKit

class CameraPosition: NSObject, MKAnnotation {

    var title: String?
    var coordinate: CLLocationCoordinate2D
    var imageUrl: String?
    var imageMetadata: ImageMetadata?

    init(coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init()) {
        self.coordinate = coordinate
    }

    init(title: String?, coordinate: CLLocationCoordinate2D, imageUrl: String?, imageMetadata: ImageMetadata?) {
        self.title = title
        self.coordinate = coordinate
        self.imageUrl = imageUrl
        self.imageMetadata = imageMetadata
    }

    init(camera: Camera) {
        self.title = camera.cameraId
        if let latitudeValue = camera.location?.latitude, let longitudeValue = camera.location?.longitude {
            let location = CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue)
            self.coordinate = location
        } else {
            self.coordinate = CLLocationCoordinate2D.init()
        }
        self.imageUrl = camera.image
        self.imageMetadata = camera.imageMetadata
    }

}
