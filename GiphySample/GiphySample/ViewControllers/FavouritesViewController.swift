//
//  FavouritesViewController.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 04/12/20.
//

import UIKit
import RxSwift

final class FavouritesViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var favouritesCollectionVw: UICollectionView!
    
    // MARK: Internal IVars
    var viewModel: FavouritesViewModel!
    
    // MARK: Private ICons
    private let _disposeBag = DisposeBag()
    
    // MARK: Private IVars
    private var _modelOutput: FavouritesViewModel.Output?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _configureNavBar()
        _configureFavouritesCollectionVw()
        _bindViewModel()
    }
}

// MARK: Helper Functions
private extension FavouritesViewController {
    func _configureNavBar() {
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func _configureFavouritesCollectionVw() {
        favouritesCollectionVw.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        if let layout = favouritesCollectionVw.collectionViewLayout as? FavouritesCollectionViewLayout {
            layout.delegate = self
        }
        
        favouritesCollectionVw.rx.itemSelected.subscribe(onNext: { [weak self] in
            self?.favouritesCollectionVw.deselectItem(at: $0, animated: true)
        })
        .disposed(by: _disposeBag)
        
        favouritesCollectionVw.backgroundView = nil
        favouritesCollectionVw.backgroundColor = .clear
    }
    
    func _bindViewModel() {
        let favouriteTapped = PublishSubject<FavouritesViewModel.Input.FavouriteState>()
        
        let input = FavouritesViewModel.Input(favouriteTapped: favouriteTapped)
        let output = viewModel.connect(input)
        _modelOutput = output

        output.favouriteGifsRelay
            .observeOn(MainScheduler.instance)
            .bind(to: favouritesCollectionVw.rx.items(cellIdentifier: GifCollectionViewCell.reuseId, cellType: GifCollectionViewCell.self)) { index, cVCellVm, cell in
                cell.bindViewModel(viewModel: cVCellVm, favouriteTapped: favouriteTapped.asObserver())
            }
            .disposed(by: _disposeBag)
    }
}

extension FavouritesViewController: FavouritesCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 200
        guard let mOutput = _modelOutput else { return height }
        let vals = mOutput.favouriteGifsRelay.value
        if (0..<vals.count).contains(indexPath.row) {
            height = CGFloat(vals[indexPath.row].height)
        }
        return height
    }
}
