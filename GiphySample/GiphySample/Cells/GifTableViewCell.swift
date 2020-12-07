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
    static let verticalPadding: CGFloat = 3
    
    // MARK: Private ICons
    private let _containerVw: UIView = {
        let vw = UIView()
        vw.layer.cornerRadius = 6
        vw.clipsToBounds = true
        vw.translatesAutoresizingMaskIntoConstraints = false; return vw
    }()
    
    // MARK: Private IVars
    private lazy var _gifImgVw: GiphyYYAnimatedImageView = {
        let vw = GiphyYYAnimatedImageView()
        vw.translatesAutoresizingMaskIntoConstraints = false; return vw
    }()
    private lazy var _favBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "heart"), for: .normal) // NO I18N
        btn.setImage(UIImage(systemName: "heart.fill"), for: .selected) // NO I18N
        btn.tintColor = .white
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.addTarget(self, action: #selector(self._favBtnTapped), for: .touchUpInside)
        btn.isHidden = true
        btn.translatesAutoresizingMaskIntoConstraints = false; return btn
    }()
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
        _favBtn.isHidden = true
    }
}

// MARK: Internal Functions
internal extension GifTableViewCell {
    func bindViewModel<O>(viewModel: GifTVCellViewModel, favouriteTapped: O) where O: ObserverType, O.Element == String {
        
        _viewModel = viewModel
        _adjustGifImgVwDimensions(viewModel: viewModel)
        _viewModel?.gifImage.subscribeOn(MainScheduler.instance).bind(onNext: { [weak self] in
            self?._gifImgVw.image = $0
            self?._favBtn.isHidden = ($0 == nil)
            
            print("Received Gif: _viewModel?.title: \(self?._viewModel?.title)")
        })
        .disposed(by: _disposeBag)
        
        _favBtn.rx.tap
            .map { viewModel.id }
            .bind(to: favouriteTapped)
            .disposed(by: _disposeBag)
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
        
        _addFavouriteBtnHierarchy()
    }
    
    func _addFavouriteBtnHierarchy() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        _containerVw.addSubview(container)
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 120),
            container.heightAnchor.constraint(equalToConstant: 120),
            container.centerXAnchor.constraint(equalTo: container.superview!.trailingAnchor),
            container.centerYAnchor.constraint(equalTo: container.superview!.bottomAnchor),
        ])
        
        let triangleImg = UIImage(systemName: "triangle.fill")?.withAlignmentRectInsets(UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        let bgImgVw = UIImageView(image: triangleImg)
        bgImgVw.tintColor = .black
        bgImgVw.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(bgImgVw)
        bgImgVw.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bgImgVw]|", metrics: nil, views: ["bgImgVw": bgImgVw]))
        bgImgVw.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bgImgVw]", metrics: nil, views: ["bgImgVw": bgImgVw]))
        bgImgVw.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.5).isActive = true
        
        _containerVw.addSubview(_favBtn)
        NSLayoutConstraint.activate([
            _favBtn.widthAnchor.constraint(equalToConstant: 24),
            _favBtn.heightAnchor.constraint(equalToConstant: 22),
            _favBtn.trailingAnchor.constraint(equalTo: container.superview!.trailingAnchor, constant: -4),
            _favBtn.bottomAnchor.constraint(equalTo: container.superview!.bottomAnchor, constant: -4),
        ])
    }
    
    @objc func _favBtnTapped(btn: UIButton) {
        btn.isSelected = !btn.isSelected
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
