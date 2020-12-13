//
//  ProviderFactory.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import UIKit
import Moya

protocol ProviderFactory {
    var trafficProvider: MoyaProvider<TrafficTarget> { get }
}

struct ConcreteProviderFactory: ProviderFactory {
    static let shared = ConcreteProviderFactory()
    let trafficProvider: MoyaProvider<TrafficTarget> = MoyaProvider<TrafficTarget>()
}
