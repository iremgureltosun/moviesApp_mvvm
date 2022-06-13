//
//  ListMoviesViewController.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Combine
import os.log
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
    var searchService: SearchServiceProtocol!
    var viewModel: HomeViewModel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var upcomingTableView: UITableView!
    @IBOutlet var nowPlayingSlider: UICollectionView!
    private var upcomingCancellables: Set<AnyCancellable> = []
    private var nowPlayingCancellables: Set<AnyCancellable> = []
    let cellRowHeight = 160

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        searchService = (appDelegate.assembler?.resolver.resolve(SearchServiceProtocol.self))!

        // to ignore safe area
        navigationController?.navigationBar.isHidden = true
        nowPlayingSlider.contentInsetAdjustmentBehavior = .never
        view.insetsLayoutMarginsFromSafeArea = false

        viewModel = HomeViewModel() // Service is resolved inside view model init.

        // Registering my table view for upcoming movies
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self

        let cellNibUpcoming = UINib(nibName: ListViewCell.cellNibIdentifier, bundle: nil)
        upcomingTableView.register(cellNibUpcoming, forCellReuseIdentifier: ListViewCell.cellReuseIdentifier)

        // Registering my collection view for now playing movies
        nowPlayingSlider.delegate = self
        nowPlayingSlider.dataSource = self

        let cellNibSlider = UINib(nibName: SliderViewCell.cellNibIdentifier, bundle: nil)
        nowPlayingSlider.register(cellNibSlider, forCellWithReuseIdentifier: SliderViewCell.cellReuseIdentifier)

        bindViewModelForUpcoming()
        bindViewModelForNowPlaying()

        fetchUpcoming()
    }
    override func viewDidLayoutSubviews() {
        myCollectionViewHeight = nowPlayingSlider.bounds.size.height
    }
    
    private func bindViewModelForNowPlaying() {
        viewModel.$nowPlayingMovies
            .receive(on: queue)
            .sink {
                [weak self] _ in
                self?.upcomingTableView.reloadData()
            }
            .store(in: &nowPlayingCancellables)
    }

    private func bindViewModelForUpcoming() {
        viewModel.$upcomingMovies
            .receive(on: queue)
            .sink { [weak self] _ in
                self?.nowPlayingSlider.reloadData()
            }
            .store(in: &upcomingCancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        // upcomingTableView.reloadData()
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

    var searchCancellableUpcoming: AnyCancellable?
    var searchCancellableNowPlaying: AnyCancellable?
    let queue = DispatchQueue.main

    func fetchUpcoming() {
        var welcome: Welcome?
        searchCancellableUpcoming = searchService.getUpcomingMovies()
            .receive(on: queue)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.viewModel.upcomingMovies = []
                case .finished:
                    let captured = welcome?.results.compactMap { UpcomingViewModel($0) } ?? []
                    print("captured results")
                    self.viewModel.upcomingMovies = captured

                    self.fetchNowPlaying()
                }

            }, receiveValue: { data in
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    welcome = try decoder.decode(Welcome.self, from: data)

                    os_log("Success: %s", log: Log.network, type: .default, "Loaded")
                } catch {
                    let errorMessage = "\(error)"
                    os_log("Error: %s", log: Log.data, type: .error, errorMessage)
                }
            })
    }

    func fetchNowPlaying() {
        var welcome: Welcome?
        searchCancellableNowPlaying = searchService.getNowPlayingMovies()
            .receive(on: queue)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.viewModel.nowPlayingMovies = []
                case .finished:
                    guard let item = welcome?.results else {
                        return
                    }
                    if item.count > 3 {
                        let captured = welcome?.results[0 ..< 3].compactMap { NowPlayingViewModel($0) } ?? []
                        print("captured nowplaying")
                        self.viewModel.nowPlayingMovies = captured
                    }
                }

            }, receiveValue: { data in
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    welcome = try decoder.decode(Welcome.self, from: data)

                    os_log("Success: %s", log: Log.network, type: .default, "Loaded")
                } catch {
                    let errorMessage = "\(error.localizedDescription)"
                    os_log("Error: %s", log: Log.data, type: .error, errorMessage)
                }
            })
    }
    var myCollectionViewHeight: CGFloat = 0.0 {
        didSet {
            if myCollectionViewHeight != oldValue {
                nowPlayingSlider.collectionViewLayout.invalidateLayout()
                nowPlayingSlider.collectionViewLayout.prepare()
            }
        }
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

// MARK: - Table View

extension ListMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upcomingMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.cellReuseIdentifier, for: indexPath) as! UpcomingTableCell
        let model = viewModel.upcomingMovies[indexPath.row]
        cell.viewModel = model
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellRowHeight)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = MovieDetailsViewController.loadFromNib()
        let model = viewModel.upcomingMovies[indexPath.row]
        view.viewModel = model
        navigationController?.pushViewController(view, animated: true)
    }
}
