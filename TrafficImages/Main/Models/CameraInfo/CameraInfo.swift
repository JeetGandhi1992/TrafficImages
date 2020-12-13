//
//  CameraInfo.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import Foundation

// MARK: - CameraInfo
public struct CameraInfo: Codable {
    var items: [Item]?
    var apiInfo: APIInfo?
}

// MARK: - APIInfo
public struct APIInfo: Codable {
    var status: String?
}

// MARK: - Item
public struct Item: Codable {
    var timestamp: Date?
    var cameras: [Camera]?
}

// MARK: - Camera
public struct Camera: Codable {
    var timestamp: Date?
    var image: String?
    var location: Location?
    var cameraId: String?
    var imageMetadata: ImageMetadata?
}

// MARK: - ImageMetadata
public struct ImageMetadata: Codable {
    var height, width: Int?
    var md5: String?
}

// MARK: - Location
public struct Location: Codable {
    var latitude, longitude: Double?
}
