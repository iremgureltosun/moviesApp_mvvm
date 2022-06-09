//
//  MovieDetailsViewController.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import UIKit

class MovieDetailsViewController: BaseViewController {
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var overview: UILabel!
   

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    var viewModel: UpcomingViewModel? 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.title = viewModel?.titleYear
        dateLabel.text = viewModel?.date ?? ""
        if let path = viewModel?.imagePath {
            imageView.loadFrom(urlPath: path)
        }
        scoreLabel.text = viewModel?.score ?? ""
        movieTitle.text = viewModel?.titleYear ?? ""
        overview.text = viewModel?.plot ?? ""
    }
}
