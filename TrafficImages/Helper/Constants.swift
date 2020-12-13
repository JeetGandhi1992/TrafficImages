//
//  Constants.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import Foundation

class Constants {

    static let shared = Constants()

    static let baseURL = URL(string: Constants.shared.getAPIBaseURL(key: "APIURLEndpoint"))!

    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        return dateFormatter
    }

    static let timeInterval: TimeInterval = 20

    fileprivate func getAPIBaseURL(key: String) -> String {
        guard let urlStr = (Bundle.main.object(forInfoDictionaryKey: key) as? String)?.trimmingCharacters(in: .whitespaces) else {
            return ""
        }
        return urlStr
    }



}

