//
//  Router.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import UIKit

protocol RouterProtocol {
    func viewController(forViewModel viewModel: Any) -> UIViewController
}

struct Router: RouterProtocol {
    func viewController(forViewModel viewModel: Any) -> UIViewController {
        switch viewModel {

            // MARK: OTHERS
            case let viewModel as MainMapViewModel:
                return UIViewController.make(viewController: MainMapViewController.self, viewModel: viewModel)
            case let viewModel as CameraDetailViewModel:
                return UIViewController.make(viewController: CameraDetailViewController.self, viewModel: viewModel)

            default:
                fatalError("Unable to find corresponding View Controller for \(viewModel)")
        }
    }

}
