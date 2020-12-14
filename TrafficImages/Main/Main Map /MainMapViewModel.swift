//
//  MainMapViewModel.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Moya

public enum MainMapViewModelEvents {
    case getTrafficImages(NetworkingUIEvent<CameraInfo>)
    case ignore

}

extension MainMapViewModelEvents: Equatable {
    public static func == (lhs: MainMapViewModelEvents, rhs: MainMapViewModelEvents) -> Bool {
        switch (lhs, rhs) {
            case (.getTrafficImages(let lCameraInfo), .getTrafficImages(let rCameraInfo)):
                return lCameraInfo == rCameraInfo
            case (.ignore, .ignore):
                return true
            default:
                return false
        }
    }
}

extension MainMapViewModelEvents: MapsToNetworkEvent {
    public func toNetworkEvent() -> NetworkingUIEvent<()>? {
        switch self {
            case .getTrafficImages(let event):
                return event.ignoreResponse()
            case .ignore:
                return nil
        }
    }
}

protocol MainMapViewModelType: NetworkingViewModel {
    var cameras: BehaviorRelay<[CameraPosition]> { get }
    var events: PublishSubject<MainMapViewModelEvents> { get }
    var timeStamp: Date { get }
    var refreshInterval: TimeInterval { get }
}

class MainMapViewModel: MainMapViewModelType {

    var cameras: BehaviorRelay<[CameraPosition]> = BehaviorRelay(value: [])
    var events: PublishSubject<MainMapViewModelEvents> = PublishSubject<MainMapViewModelEvents>()

    let service: TrafficService
    let disposeBag = DisposeBag()
    let selectedCameraPosition = PublishSubject<(cameraPosition: CameraPosition, timeStamp: Date)>()
    var timeStamp: Date
    var refreshInterval: TimeInterval

    init(provider: MoyaProvider<TrafficTarget>, refreshInterval: TimeInterval, timeStamp: Date = Date()) {
        self.service = TrafficService(provider: provider)
        self.refreshInterval = refreshInterval
        self.timeStamp = timeStamp
        self.setupBindCameraInfo()
    }

    private func setupBindCameraInfo() {
        self.events.subscribe(onNext: { [weak self] (event) in
            guard let self = self else { return }
            switch event {
                case .getTrafficImages(.succeeded(let cameraInfo)):
                    let cameras = (cameraInfo.items?.first?.cameras ?? [])
                    let cameraPositions = cameras.map { CameraPosition(camera: $0) }
                    self.cameras.accept(cameraPositions)
                default:
                    break
            }
        }).disposed(by: disposeBag)
    }

    public func getTrafficImages() {
        timeStamp = Date()
        let dateStr = Constants.dateFormatter.string(from: timeStamp)
        service.getTrafficImages(for: dateStr)
            .map { MainMapViewModelEvents.getTrafficImages($0) }
            .subscribe(onNext: { [weak self] (event) in
                guard let self = self else { return }
                self.events.onNext(event)
            })
            .disposed(by: disposeBag)
    }

    public func shouldRefreshAnnotations(date: Date = Date()) -> Bool {
        let differenceInSeconds = date.timeIntervalSince(timeStamp)
        return differenceInSeconds >= 20
    }

}
