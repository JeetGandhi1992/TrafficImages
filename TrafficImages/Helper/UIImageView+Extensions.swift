//
//  UIImageView+Extensions.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {

    public func setImage(withURL: URL, placeholderImage: UIImage? = nil) {
        self.af.setImage(withURL: withURL, placeholderImage: placeholderImage)
    }

    public func setImage(withURLRequest urlRequest: URLRequest,
                         placeholderImage: UIImage? = nil) {
        self.af.setImage(withURLRequest: urlRequest, placeholderImage: placeholderImage)
    }
}
