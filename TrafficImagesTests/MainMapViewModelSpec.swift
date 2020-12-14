//
//  MainMapViewModelSpec.swift
//  TrafficImagesTests
//
//  Created by jeet_gandhi on 14/12/20.
//

import Quick
import Nimble
import RxSwift
import RxTest
import Moya

@testable import TrafficImages

class MainMapViewModelSpec: QuickSpec {

    override func spec() {
        describe("MainMapViewModelSpec") {

            var subject: MainMapViewModel!
            var provider: FakeMoyaProvider<TrafficTarget>!
            var timeStamp: Date!
            let interval: TimeInterval = 20
            var latestEvent: MainMapViewModelEvents!
            let disposeBag = DisposeBag()

            context("when traffic camera images are fetched from api and api is successful") {
                beforeEach {
                    initSubject()

                    latestEvent = ObservableHelpers.latestValueFrom(observable: subject.events, disposeBag: disposeBag, executeBlock: {
                        subject.getTrafficImages()
                        let cameraInfo = CameraInfoFactory.get_cameraInfo_for_single_camera(date: timeStamp)
                        let encoder = JSONEncoder()
                        encoder.keyEncodingStrategy = .convertToSnakeCase
                        encoder.dateEncodingStrategy = .formatted(Constants.dateFormatter)
                        let data = try! encoder.encode(cameraInfo)
                        provider.response.onNext(Response(statusCode: 200, data: data))
                    })
                }
                it("should get camera info response") {
                    guard case .getTrafficImages(.succeeded(let cameraInfo)) = latestEvent else {
                        fail()
                        return
                    }
                    let expectedCamera = CameraInfoFactory.get_single_camera(date: timeStamp)
                    let camera = cameraInfo.items?.first?.cameras?.first!

                    expect(camera?.cameraId).to(equal(expectedCamera.cameraId))
                    expect(camera?.image).to(equal(expectedCamera.image))
                    expect(camera?.location?.latitude).to(equal(expectedCamera.location?.latitude))
                    expect(camera?.location?.longitude).to(equal(expectedCamera.location?.longitude))
                    expect(subject.cameras.value.count).to(equal(1))
                }
            }

            context("when traffic camera images are fetched from api and api is failure") {
                beforeEach {
                    initSubject()

                    latestEvent = ObservableHelpers.latestValueFrom(observable: subject.events, disposeBag: disposeBag, executeBlock: {
                        subject.getTrafficImages()
                        provider.response.onNext(Response(statusCode: 500, data: Data()))
                    })

                }
                it("should get error event") {
                    guard case .getTrafficImages(.failed(let error)) = latestEvent else {
                        fail()
                        return
                    }
                    expect(subject.cameras.value.count).to(equal(0))
                    expect(error.localizedDescription).notTo(beNil())
                }
            }

            context("When time passed is more than interval") {
                beforeEach {
                    initSubject()
                }
                it("should require refresh") {
                    let advancedTime = timeStamp.advanced(by: 25)
                    let refresh = subject.shouldRefreshAnnotations(date: advancedTime)
                    expect(refresh).to(beTrue())
                }
            }

            context("When time passed is less than interval") {
                beforeEach {
                    initSubject()
                }
                it("should not require refresh") {
                    let advancedTime = timeStamp.advanced(by: 10)
                    let refresh = subject.shouldRefreshAnnotations(date: advancedTime)
                    expect(refresh).to(beFalse())
                }
            }



            func initSubject() {
                provider = FakeMoyaProvider<TrafficTarget>()
                timeStamp = Date()
                subject = MainMapViewModel(provider: provider,
                                           refreshInterval: interval,
                                           timeStamp: timeStamp)
            }
        }
    }

}

