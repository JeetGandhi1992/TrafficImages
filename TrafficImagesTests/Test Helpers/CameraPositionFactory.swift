//
//  CameraInfoFactory.swift
//  TrafficImagesTests
//
//  Created by jeet_gandhi on 13/12/20.
//

import UIKit
import MapKit

@testable import TrafficImages

public struct CameraInfoFactory {

    public static func get_cameraInfo_for_single_camera(date: Date) -> CameraInfo {
        return CameraInfo(items: [Item(timestamp: date,
                                       cameras: [Camera(timestamp: date,
                                                        image: "https://images.unsplash.com/photo-1607884272950-6aab9adcb2a0",
                                                        location: Location(latitude: 2, longitude: 2),
                                                        cameraId: "1001",
                                                        imageMetadata: nil)])],
                          apiInfo: nil)
    }

    public static func get_single_camera(date: Date) -> Camera {
        return Camera(timestamp: date,
                       image: "https://images.unsplash.com/photo-1607884272950-6aab9adcb2a0",
                       location: Location(latitude: 2, longitude: 2),
                       cameraId: "1001",
                       imageMetadata: nil)

    }

    public static func get_single_cameraPosition() -> [CameraPosition] {
        return [CameraPosition(title: "1001", coordinate: CLLocationCoordinate2D(latitude: 2, longitude: 2),
                               imageUrl: "https://images.unsplash.com/photo-1607884272950-6aab9adcb2a0",
                               imageMetadata: nil)]

    }
}
