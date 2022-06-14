//
//  ListMoviesViewController.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import os.log
import RxCocoa
import RxSwift
import UIKit

public struct ListViewCell {
    public static let cellReuseIdentifier = "UpcomingReuseId"
    public static let cellNibIdentifier = "UpcomingTableCell"
}

public struct SliderViewCell {
    public static let cellReuseIdentifier = "NowPlayingReuseId"
    public static let cellNibIdentifier = "NowPlayingSliderCell"
}

class ListMoviesViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var upcomingTableView: UITableView!
    @IBOutlet var nowPlayingSlider: UICollectionView!

    let cellRowHeight: CGFloat = 160

    override func viewDidLoad() {
        super.viewDidLoad()

        // to ignore safe area
        navigationController?.navigationBar.isHidden = true
        nowPlayingSlider.contentInsetAdjustmentBehavior = .never
        view.insetsLayoutMarginsFromSafeArea = false

        viewModel = HomeViewModel() // Service is resolved inside view model init.
        upcomingTableView.delegate = self
        nowPlayingSlider.delegate = self
        
        
        bindTableData()
        viewModel.fetchUpcoming()

        bindSlider()
        viewModel.fetchNowPlaying()
    }

    override func viewDidLayoutSubviews() {
        myCollectionViewHeight = nowPlayingSlider.bounds.size.height
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    var myCollectionViewHeight: CGFloat = 0.0 {
        didSet {
            if myCollectionViewHeight != oldValue {
                nowPlayingSlider.collectionViewLayout.invalidateLayout()
                nowPlayingSlider.collectionViewLayout.prepare()
            }
        }
    }

    private func bindTableData() {
        let nib = UINib(nibName: ListViewCell.cellNibIdentifier, bundle: nil)
        upcomingTableView.register(nib, forCellReuseIdentifier: ListViewCell.cellReuseIdentifier)

        viewModel.upcomingList
            .bind(to: upcomingTableView.rx.items(cellIdentifier: ListViewCell.cellReuseIdentifier, cellType: UpcomingTableCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)

        // MARK: For navigating to details

        upcomingTableView.rx.modelSelected(UpcomingViewModel.self).bind { [weak self] model in
            let view = MovieDetailsViewController.loadFromNib()
            view.viewModel = model
            self?.navigationController?.pushViewController(view, animated: true)

        }.disposed(by: disposeBag)
    }
    
    private func bindSlider() {
        let nib = UINib(nibName: SliderViewCell.cellNibIdentifier, bundle: nil)
        nowPlayingSlider.register(nib, forCellWithReuseIdentifier: SliderViewCell.cellReuseIdentifier)

        viewModel.nowPlayingList
            .bind(to: nowPlayingSlider.rx.items(cellIdentifier: SliderViewCell.cellReuseIdentifier, cellType: NowPlayingSliderCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Table View

extension ListMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellRowHeight
    }
}

// MARK: - Collection View

extension ListMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = nowPlayingSlider.frame.size
        return CGSize(width: size.width, height: size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

/*
 extension ListMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return viewModel.upcomingMovies.count
     }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderViewCell.cellReuseIdentifier, for: indexPath) as! NowPlayingSliderCell
         if indexPath.row < viewModel.nowPlayingMovies.count {
             let model = viewModel.nowPlayingMovies[indexPath.row]
             cell.viewModel = model
             // pageControl.currentPage = cell.viewWithTag(model.id)
         }
         return cell
     }
 }
 */
