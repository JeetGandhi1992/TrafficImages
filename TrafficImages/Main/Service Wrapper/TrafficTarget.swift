//
//  TrafficTarget.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import Moya
import Alamofire

public enum TrafficTarget {
    case getTrafficImages(urlParameters: [String : String])
}

extension TrafficTarget: TargetType {

    public var baseURL: URL {
        return Constants.baseURL
    }

    public var path: String {
        switch self {
            case .getTrafficImages:
                return "v1/transport/traffic-images/"
        }
    }

    public var method: Moya.Method {
        .get
    }

    public var sampleData: Data {
        Data()
    }

    public var task: Task {
        switch self {
            case .getTrafficImages(urlParameters: let urlParameters):
                return .requestParameters(parameters: urlParameters,
                                          encoding: URLEncoding.default)
        }

    }

    public var headers: [String : String]? {
        return nil
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

}
