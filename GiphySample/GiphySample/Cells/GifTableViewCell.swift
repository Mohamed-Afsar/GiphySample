//
//  GifTableViewCell.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import UIKit
import RxSwift
import GiphyUISDK

final class GifTableViewCell: UITableViewCell {
    // MARK: Static Cons
    static let reuseId = "GifTableViewCell" // NO I18N
    static let horizontalPadding: CGFloat = 15
    static let verticalPadding: CGFloat = 5
    
    // MARK: Private ICons
    private let _containerVw: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false; return vw
    }()
    
    private let _gifImgVw: GiphyYYAnimatedImageView = {
        let vw = GiphyYYAnimatedImageView(); vw.backgroundColor = .yellow
        vw.translatesAutoresizingMaskIntoConstraints = false; return vw
    }()
    
    // MARK: Private IVars
    private var _disposeBag = DisposeBag()
    private var _viewModel: GifTVCellViewModel?
    private lazy var _imgVwARatioConstraint = _gifImgVw.heightAnchor.constraint(equalTo: _gifImgVw.widthAnchor, multiplier: 1)
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
        _addViewHierarchy()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _viewModel?.ceaseAssetTask()
        _disposeBag = DisposeBag()
        _viewModel = nil
        _imgVwARatioConstraint.isActive = false
        _gifImgVw.image = nil
//        label.text = ""
//        label.isHidden = false
    }
}

// MARK: Internal Functions
internal extension GifTableViewCell {
    func bindViewModel<O>(viewModel: GifTVCellViewModel, favouriteTapped: O) where O: ObserverType, O.Element == String {
        
        _viewModel = viewModel
        _adjustGifImgVwDimensions(viewModel: viewModel)
        _viewModel?.gifImage.subscribeOn(MainScheduler.instance).bind(onNext: { [weak self] in
            self?._gifImgVw.image = $0
            
            print("Received Gif: _viewModel?.title: \(self?._viewModel?.title)")
        })
        .disposed(by: _disposeBag)
        
        /*
        button.rx.tap
            .map { viewModel.id }    //emit the cell's viewModel id when the button is clicked for identification purposes.
            .bind(to: buttonClicked) //problem binding because of optional.
            .disposed(by: disposeBag)
        */
    }
}

// MARK: Helper Functions
private extension GifTableViewCell {
    func _addViewHierarchy() {
        let variableBindings = ["containerVw": _containerVw, "gifImgVw": _gifImgVw]
        
        contentView.addSubview(_containerVw)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[containerVw]-(padding)-|", metrics: ["padding": GifTableViewCell.horizontalPadding], views: variableBindings)
        _containerVw.superview?.addConstraints(hConstraints)
        
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[containerVw]", metrics: ["padding": GifTableViewCell.verticalPadding], views: variableBindings)
        _containerVw.superview?.addConstraints(vConstraints)
        
        let btmConstraint = _containerVw.bottomAnchor.constraint(equalTo: _containerVw.superview!.bottomAnchor, constant: -GifTableViewCell.verticalPadding)
        btmConstraint.priority = .fittingSizeLevel
        btmConstraint.isActive = true
                
        _containerVw.addSubview(_gifImgVw)
        _gifImgVw.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[gifImgVw]|", metrics: nil, views: variableBindings))
        _gifImgVw.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[gifImgVw]|", metrics: nil, views: variableBindings))
        _imgVwARatioConstraint.isActive = true
    }
    
    func _adjustGifImgVwDimensions(viewModel: GifTVCellViewModel) {
        let multiplier: CGFloat
        if let height = Float(viewModel.imageMeta.height), let width = Float(viewModel.imageMeta.width) {
            let ratio = CGFloat(height/width)
            multiplier = (ratio * 100).rounded(.down) / 100
        }
        else {
            multiplier = 1
        }
        _imgVwARatioConstraint.isActive = false
        _imgVwARatioConstraint = _gifImgVw.heightAnchor.constraint(equalTo: _gifImgVw.widthAnchor, multiplier: multiplier)
        _imgVwARatioConstraint.isActive = true
    }
}
