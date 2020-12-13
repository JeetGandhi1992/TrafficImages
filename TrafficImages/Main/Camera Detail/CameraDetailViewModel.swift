//
//  CameraDetailViewModel.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 14/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Moya

protocol CameraDetailViewModelType {
    var cameraPosition: CameraPosition { get }
    var timeStamp: Date { get }
}

class CameraDetailViewModel: CameraDetailViewModelType {

    var cameraPosition: CameraPosition
    var timeStamp: Date

    init(cameraPosition: CameraPosition, timeStamp: Date) {
        self.cameraPosition = cameraPosition
        self.timeStamp = timeStamp
    }


}
