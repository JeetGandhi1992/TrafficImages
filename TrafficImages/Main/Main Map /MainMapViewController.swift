//
//  MainMapViewController.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class MainMapViewController: UIViewController, NetworkingViewController {

    var alertPresenter: AlertPresenterType = AlertPresenter()
    var loadingSpinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    var viewModel: MainMapViewModel!
    var previousCameraPosition: CameraPosition?

    let disposeBag = DisposeBag()

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Traffic Cameras"
        self.setupLoadingSpinner()
        self.setupNetworkingEventsUI()
        self.getTrafficCameras()
        self.setupMapView()
        self.setupRefreshButton()
        // Do any additional setup after loading the view.
    }

    func setupRefreshButton() {
        let refresh = UIImage(systemName: "arrow.clockwise.circle")
        let refreshBarButton = UIBarButtonItem(image: refresh, style: .plain, target: self, action: #selector(MainMapViewController.refreshTrafficImages))
        self.navigationItem.rightBarButtonItem  = refreshBarButton
    }

    @objc func refreshTrafficImages(sender: UIBarButtonItem) {
        self.viewModel.getTrafficImages()
    }

    func getTrafficCameras() {
        self.rx.viewWillAppear
            .do(onNext: { (isFirstTime) in
                if isFirstTime || self.viewModel.shouldRefreshAnnotations() {
                    self.viewModel.getTrafficImages()
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }

    func setupMapView() {
        self.viewModel.cameras
            .asDriver()
            .drive(onNext: { [unowned self] (cameraPositions) in
                let allAnnotations = self.mapView.annotations
                self.mapView.removeAnnotations(allAnnotations)
                self.mapView.addAnnotations(cameraPositions)

                guard self.previousCameraPosition != nil,
                      let title = self.previousCameraPosition?.title,
                      let cameraPosition = cameraPositions.filter({ $0.title == title }).first else {
                    self.previousCameraPosition = nil
                    return
                }
                self.mapView.selectAnnotation(cameraPosition,
                                              animated: true)

            })
            .disposed(by: disposeBag)

        self.mapView.delegate = self
    }

}

extension MainMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cameraPosition = view.annotation as? CameraPosition {
            if !self.viewModel.shouldRefreshAnnotations() {
                previousCameraPosition = nil
                self.viewModel.selectedCameraPosition.onNext((cameraPosition, viewModel.timeStamp))
            } else {
                self.previousCameraPosition = cameraPosition
                self.viewModel.getTrafficImages()
            }
        }
    }

}
