//
//  FakeProvider.swift
//  TrafficImagesTests
//
//  Created by jeet_gandhi on 13/12/20.
//

@testable import TrafficImages

import Moya
import RxSwift

public struct FakeCommonProviderFactory: ProviderFactory {
    public var trafficProvider: MoyaProvider<TrafficTarget>

    init() {
        trafficProvider = FakeMoyaProvider<TrafficTarget>()
    }
}


public class FakeMoyaProvider<T: TargetType>: MoyaProvider<T> {

    public let responseStatusCode = PublishSubject<Int>()
    public let errorResponse = PublishSubject<Data>()
    public let response = PublishSubject<Response>()
    private let disposeBag = DisposeBag()

    public var sampleData: Data?
    public var targetArgument: T!

    public init() {
        super.init()
    }

    public override func request(_ target: T,
                                 callbackQueue: DispatchQueue?,
                                 progress: ProgressBlock?,
                                 completion: @escaping Completion) -> Cancellable {
        targetArgument = target

        responseStatusCode
            .map { statusCode in
                var data: Data
                if statusCode == 200 {
                    if let sampleData = self.sampleData {
                        data = sampleData
                    } else {
                        data = target.sampleData
                    }
                } else {
                    if let sampleData = self.sampleData {
                        data = sampleData
                    } else {
                        data = Data("{\"message\": \"Server error\"}".data(using: .utf8)!)
                    }
                }
                return Response(statusCode: statusCode, data: data)
            }
            .bind(to: self.response)
            .disposed(by: disposeBag)

        errorResponse
            .map {
                return Response(statusCode: 500, data: $0)
            }
            .bind(to: self.response)
            .disposed(by: disposeBag)

        response
            .subscribe(onNext: {  completion(.success($0)) })
            .disposed(by: disposeBag)

        return CancellableToken(action: {})
    }
}
