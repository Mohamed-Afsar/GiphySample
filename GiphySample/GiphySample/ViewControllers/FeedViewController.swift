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
    
    // MARK: Private ICons
    private let _disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        _bindViewModel()
        viewModel.loadTrendingGifs()
    }
}

// MARK: Helper Functions
private extension FeedViewController {
    func _bindViewModel() {
        let favouriteTapped = PublishSubject<String>()
        let input = FeedViewModel.Input(favouriteTapped: favouriteTapped)
        let output = viewModel.connect(input)
        output.trendingGifsDriver.drive(feedTableVw.rx.items(cellIdentifier: GifTableViewCell.reuseId, cellType: GifTableViewCell.self)) { index, gifVm, cell in
            
            print("feedTableVw.rx.items: index: \(index)")
            
            cell.bindViewModel(viewModel: gifVm, favouriteTapped: favouriteTapped.asObserver())
            
            ////
            #warning("Temp Code")
            cell.textLabel?.text = gifVm.title
            ////
        }
        .disposed(by: _disposeBag)
    }
}
