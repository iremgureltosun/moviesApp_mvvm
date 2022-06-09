//
//  CollectionViewCell.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import UIKit

class NowPlayingSliderCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var title: UILabel!

   
    var viewModel: NowPlayingViewModel? {
        didSet {
            title.text = viewModel?.titleYear ?? ""
            subtitle.text = viewModel?.shortenedPlot ?? ""
            guard let path = viewModel?.imagePath else {
                return
            }
            imageView.loadFrom(urlPath: path)
            self.tag = viewModel?.id ?? 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
