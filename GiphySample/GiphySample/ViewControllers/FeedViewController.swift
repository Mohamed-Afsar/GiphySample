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
    
    ////////////////////////
    #warning("Temp Code")
    private let _giphyService = GiphyService()
    private let _disposeBag = DisposeBag()
    ////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ////////////////////////
        #warning("Temp Code")
        let observable = _giphyService.getTrendingGifs(offset: 0)
        observable.subscribe(onNext: {
            print("observable: TrendingObject: \($0)")
        }, onError: {
            print("observable: error: \($0)")
        }, onCompleted: {
            print("observable: Completed")
        }, onDisposed: {
            print("observable: onDisposed")
        }).disposed(by: _disposeBag)
        
        observable.map { $0.data }.bind(to: feedTableVw.rx.items(cellIdentifier: GifTableViewCell.reuseId, cellType: GifTableViewCell.self)) { index, gifModel, cell in
            cell.textLabel?.text = gifModel.title
        }.disposed(by: _disposeBag)
        
        ////////////////////////
    }
}
