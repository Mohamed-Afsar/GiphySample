//
//  FeedViewController.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 04/12/20.
//

import UIKit
import RxSwift
import RxCocoa

final class FeedViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var feedTableVw: UITableView!
    
    // MARK: Internal IVars
    var viewModel: FeedViewModel!
    
    // MARK: Private Static ICons
    private static let kStartLoadingOffset: CGFloat = 200.0
    
    // MARK: Private ICons
    private let _disposeBag = DisposeBag()
    private let _favouriteTapped = PublishSubject<FeedViewModel.Input.FavouriteState>()
    private let _feedActivityIndicator: UIActivityIndicatorView = {
        let aVw = UIActivityIndicatorView(style: .large)
        aVw.translatesAutoresizingMaskIntoConstraints = false
        aVw.color = .darkGray
        aVw.hidesWhenStopped = true
        return aVw
    }()

    // MARK: Private IVars
    private var _tableBindingDisposeBag = DisposeBag()
    private lazy var _searchController: UISearchController = {
        let sController = UISearchController(searchResultsController: nil)
        sController.obscuresBackgroundDuringPresentation = false
        sController.searchBar.sizeToFit()
        sController.searchBar.barStyle = .black
        sController.searchBar.tintColor = .white
        sController.searchBar.barTintColor = .black
        sController.searchBar.backgroundColor = .clear
        sController.searchBar.placeholder = "Search gifs..."
        return sController
    }()
    private var _viewModelOutput: FeedViewModel.Output?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _configureNavBar()
        _configureFeedActivityIndicator()
        _configureFeedTable()
        _configureFeedEnvironmet()
        _bindViewModel()
        
        viewModel.loadTrendingGifs()
    }
}

// MARK: Helper Functions
private extension FeedViewController {
    func _configureNavBar() {
        navigationItem.searchController = _searchController
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        
        // to force large title - 6 Dec 2020
        feedTableVw.setContentOffset(.init(x: 0, y: -1), animated: false)
    }
    
    func _configureFeedActivityIndicator() {
        view.addSubview(_feedActivityIndicator)
        _feedActivityIndicator.centerXAnchor.constraint(equalTo: _feedActivityIndicator.superview!.centerXAnchor).isActive = true
        _feedActivityIndicator.centerYAnchor.constraint(equalTo: _feedActivityIndicator.superview!.centerYAnchor).isActive = true
    }
    
    func _configureFeedTable() {
        feedTableVw.rx.itemSelected.subscribe(onNext: { [weak self] in
            self?.feedTableVw.deselectRow(at: $0, animated: true)
            if self?._searchController.isActive ?? false {
                self?._searchController.dismiss(animated: true, completion: nil)
            }
        })
        .disposed(by: _disposeBag)
        
        feedTableVw.backgroundView = nil
        feedTableVw.backgroundColor = .clear
        
        feedTableVw.rx
            .contentOffset
            .subscribe { [weak self] in
                guard let strongSelf = self, let offset = $0.element else { return }
                if strongSelf._isNearTheBottomEdge(contentOffset: offset, strongSelf.feedTableVw) {
                    if strongSelf.feedTableVw.visibleCells.count > 0 {
                        if strongSelf._searchController.isActive {
                            strongSelf.viewModel.loadSearchedGifs()
                        }
                        else {
                            strongSelf.viewModel.loadTrendingGifs()
                        }
                    }
                }
            }
            .disposed(by: _disposeBag)
    }
    
    func _configureFeedEnvironmet() {
        keyboardHeightObservable()
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] in
                self?.feedTableVw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: $0, right: 0)
            })
            .disposed(by: _disposeBag)
        
        _searchController.rx.willPresent.subscribe(onNext: { [weak self] in
            guard let strongSelf = self, let output = strongSelf._viewModelOutput else { return }
            strongSelf._bind(table: strongSelf.feedTableVw, driver: output.searchedGifsDriver, buttonTap: strongSelf._favouriteTapped)
        })
        .disposed(by: _disposeBag)

        _searchController.rx.willDismiss.subscribe(onNext: { [weak self] in
            guard let strongSelf = self, let output = strongSelf._viewModelOutput else { return }
            strongSelf._bind(table: strongSelf.feedTableVw, driver: output.trendingGifsDriver, buttonTap: strongSelf._favouriteTapped)
        })
        .disposed(by: _disposeBag)
    }
    
    func _bindViewModel() {
        let searchTextDriver = _searchController.searchBar.searchTextField.rx.text.orEmpty.asDriver()
        
        let input = FeedViewModel.Input(favouriteTapped: _favouriteTapped, searchTextDriver: searchTextDriver)
                
        let output = viewModel.connect(input)
        _viewModelOutput = output
        
        output.isFetchingTrendingGifsDriver
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                if strongSelf.feedTableVw.visibleCells.count > 0 {
                    strongSelf._feedActivityIndicator.stopAnimating()
                }
                else {
                    strongSelf._feedActivityIndicator.startAnimating()
                }
            })
            .disposed(by: _disposeBag)
        
        output.isSearchingGifsDriver
            .drive(onNext: { [weak self] in
                self?._searchController.searchBar.isLoading = $0
            })
            .disposed(by: _disposeBag)
            
        self._bind(table: self.feedTableVw, driver: output.trendingGifsDriver, buttonTap: _favouriteTapped)
    }
    
    func _bind(table: UITableView, driver: Driver<[GifTVCellViewModel]>, buttonTap: PublishSubject<FeedViewModel.Input.FavouriteState>) {
        self._tableBindingDisposeBag = DisposeBag()
        driver.drive(table.rx.items(cellIdentifier: GifTableViewCell.reuseId, cellType: GifTableViewCell.self)) { [weak self] index, gifVm, cell in
            cell.bindViewModel(viewModel: gifVm, favouriteTapped: buttonTap.asObserver())
            
            if let strongSelf = self {
                strongSelf._viewModelOutput?.favouritesStateRelay
                    .bind(to: gifVm.favouritesUpdate)
                    .disposed(by: strongSelf._tableBindingDisposeBag)
            }            
        }
        .disposed(by: self._tableBindingDisposeBag)
    }
    
    func _isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + FeedViewController.kStartLoadingOffset > tableView.contentSize.height
    }
}
