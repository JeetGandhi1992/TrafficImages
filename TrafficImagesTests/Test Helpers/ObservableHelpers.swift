//
//  ObservableHelpers.swift
//  TrafficImagesTests
//
//  Created by jeet_gandhi on 13/12/20.
//

import Foundation

import RxSwift
import RxTest

public struct ObservableHelpers {

    public static func latestValueFrom<T>(observable: Observable<T>,
                                          disposeBag: DisposeBag,
                                          executeBlock: (() -> Void)? = nil) -> T? {
        let events = self.events(from: observable,
                                 disposeBag: disposeBag,
                                 executeBlock: executeBlock)
        return events.last?.value.element
    }

    public static func events<T>(from observable: Observable<T>,
                                 disposeBag: DisposeBag,
                                 executeBlock: (() -> Void)? = nil) -> [Recorded<Event<T>>] {
        let testScheduler = TestScheduler(initialClock: 0)
        let testObserver = testScheduler.createObserver(T.self)

        observable
            .bind(to: testObserver)
            .disposed(by: disposeBag)

        if let executeBlock = executeBlock { executeBlock() }

        return testObserver.events
    }
}
