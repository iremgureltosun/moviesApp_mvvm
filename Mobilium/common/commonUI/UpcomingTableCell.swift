//
//  UpcomingTableCell.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import UIKit

class UpcomingTableCell: UITableViewCell {
    @IBOutlet var shortOverView: UILabel!
    @IBOutlet var posterView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet weak var viewText: UIView!
    var viewModel: UpcomingViewModel? {
        didSet {
            title.text = viewModel?.titleYear
            shortOverView.text = viewModel?.shortenedPlot
            date.text = viewModel?.date
            guard let path = viewModel?.posterPath else {
                return
            }
            posterView.loadFrom(urlPath: path)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewText.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
