//
//  TrafficService.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import RxSwift
import RxCocoa
import Moya

public protocol TrafficServiceType {
    func getTrafficImages(for timestamp: String) -> Observable<NetworkingUIEvent<CameraInfo>>
}

public struct TrafficService: TrafficServiceType {

    let provider: MoyaProvider<TrafficTarget>
    let disposeBag = DisposeBag()

    public init(provider: MoyaProvider<TrafficTarget>) {
        self.provider = provider
    }

    public func getTrafficImages(for timestamp: String) -> Observable<NetworkingUIEvent<CameraInfo>> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(Constants.dateFormatter)
        return self.provider.rx
            .request(TrafficTarget.getTrafficImages(urlParameters: ["date_time" : timestamp]))
            .map(CameraInfo.self, using: decoder, failsOnEmptyData: true)
            .map({ (result) -> NetworkingUIEvent<CameraInfo> in
                return NetworkingUIEvent.succeeded(result)
            })
            .asObservable()
            .startWith(.waiting)
            .catchError { (error) -> Observable<NetworkingUIEvent<CameraInfo>> in
                return Observable.just(NetworkingUIEvent.failed(error))
            }
    }

}
