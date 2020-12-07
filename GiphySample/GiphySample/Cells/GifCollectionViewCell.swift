//
//  GifCollectionViewCell.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import UIKit
import RxSwift
import GiphyUISDK

final class GifCollectionViewCell: UICollectionViewCell {
    // MARK: Static Cons
    static let reuseId = "GifCollectionViewCell" // NO I18N
    static let horizontalPadding: CGFloat = 3
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
        vw.clipsToBounds = true
        vw.contentMode = .scaleAspectFill
        vw.translatesAutoresizingMaskIntoConstraints = false; return vw
    }()
    private lazy var _favBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "heart"), for: .normal) // NO I18N
        btn.setImage(UIImage(systemName: "heart.fill"), for: .selected) // NO I18N
        btn.tintColor = .white
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.isSelected = true
        btn.translatesAutoresizingMaskIntoConstraints = false; return btn
    }()
    private var _disposeBag = DisposeBag()
    private var _viewModel: GifCnVwCellViewModel?
    
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
        _disposeBag = DisposeBag()
        _viewModel = nil
        _gifImgVw.image = nil
        _favBtn.isSelected = true
    }
}

// MARK: Internal Functions
internal extension GifCollectionViewCell {
    func bindViewModel<O>(viewModel: GifCnVwCellViewModel, favouriteTapped: O) where O: ObserverType, O.Element == FeedViewModel.Input.FavouriteState {
        
        _viewModel = viewModel
        let imgUrl = CoreDataManager.shared.documentsDirectory.appendingPathComponent(viewModel.relativeDocDirImgPath)
        
        let image = GiphyYYImage(contentsOfFile: imgUrl.path)
        _gifImgVw.image = image
        
        _favBtn.rx.tap
            .map { [weak self] () -> FavouritesViewModel.Input.FavouriteState in
                var isFavourite = false
                let imgData = image?.animatedImageData ?? Data()
                if let strongSelf = self {
                    strongSelf._favBtn.isSelected = !strongSelf._favBtn.isSelected
                    isFavourite = strongSelf._favBtn.isSelected
                }
                let gifImage = GifImage(id: viewModel.id, data: imgData, width: viewModel.width, height: viewModel.height)
                return (isFavourite: isFavourite, image: gifImage)
             }
            .bind(to: favouriteTapped)
            .disposed(by: _disposeBag)
    }
}

// MARK: Helper Functions
private extension GifCollectionViewCell {
    func _addViewHierarchy() {
        let variableBindings = ["containerVw": _containerVw, "gifImgVw": _gifImgVw]
        
        contentView.addSubview(_containerVw)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[containerVw]-(padding)-|", metrics: ["padding": GifCollectionViewCell.horizontalPadding], views: variableBindings)
        _containerVw.superview?.addConstraints(hConstraints)
        
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[containerVw]-(padding)-|", metrics: ["padding": GifCollectionViewCell.verticalPadding], views: variableBindings)
        _containerVw.superview?.addConstraints(vConstraints)
                        
        _containerVw.addSubview(_gifImgVw)
        _gifImgVw.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[gifImgVw]|", metrics: nil, views: variableBindings))
        _gifImgVw.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[gifImgVw]|", metrics: nil, views: variableBindings))
        
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
}
