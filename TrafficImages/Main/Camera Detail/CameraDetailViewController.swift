//
//  CameraDetailViewController.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 14/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class CameraDetailViewController: UIViewController, ViewControllerProtocol {

    var viewModel: CameraDetailViewModel!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var cameraName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        self.timeStamp.text = Constants.dateFormatter.string(from: self.viewModel.timeStamp)
        self.cameraName.text = self.viewModel.cameraPosition.title
        if let url = URL(string: self.viewModel.cameraPosition.imageUrl ?? "") {
            self.imageView.setImage(withURL: url)
        }

    }

}
