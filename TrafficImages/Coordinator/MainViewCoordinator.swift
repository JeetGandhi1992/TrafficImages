//
//  MainViewCoordinator.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewCoordinator {

    public static let shared = MainViewCoordinator(providerFactory: ConcreteProviderFactory.shared)
    let disposeBag = DisposeBag()

    var mainRootController: UIViewController!
    var providerFactory: ProviderFactory

    init(providerFactory: ProviderFactory) {
        self.providerFactory = providerFactory
        self.mainRootController = MainViewCoordinator.getMainMapViewController(providerFactory: providerFactory)
    }

    private static func getMainMapViewController(providerFactory: ProviderFactory) -> UIViewController {
        let viewModel = MainMapViewModel(provider: providerFactory.trafficProvider,
                                         refreshInterval: Constants.timeInterval)
        guard let viewController = Router().viewController(forViewModel: viewModel) as? MainMapViewController else {
            fatalError("MainMenuViewController not found")
        }

        viewModel.selectedCameraPosition
            .asDriver(onErrorJustReturn: (CameraPosition(), Date()))
            .drive(onNext: { [weak viewController] (cameraPosition, timeStamp) in
                let cameraDetailViewModel = CameraDetailViewModel(cameraPosition: cameraPosition, timeStamp: timeStamp)
                guard let cameraDetailViewController = Router().viewController(forViewModel: cameraDetailViewModel) as? CameraDetailViewController else {
                    fatalError("CameraDetailViewController not found")
                }
                viewController?.navigationController?.modalPresentationStyle = .fullScreen
                viewController?.navigationController?.pushViewController(cameraDetailViewController, animated: true)
            })
            .disposed(by: viewModel.disposeBag)
        return viewController
    }


}
