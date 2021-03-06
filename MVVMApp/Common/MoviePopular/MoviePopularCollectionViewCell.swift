//
//  MoviePopularCollectionViewCell.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 20/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class MoviePopularCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.text = "Popular Today"
        label.font = AppFont.getFont(fontName: .openSans_Bold, size: 22)
        return label
    }()
    
    private lazy var moviePopularCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.register(ofType: MoviePopularItemCollectionViewCell.self)
        collectionView.register(ofType: LoadMoreCollectionReusableView.self, ofKind: .footer)
        return collectionView
    }()
    
    private var viewModel: MoviePopularViewModelProtocol! {
        didSet {
            self.binding()
            self.viewModel.loadMoviePopularAction.execute(())
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createComponents()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoviePopularCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.height - 47) / 3 * 2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: AppSize.Spacing.inset.rawValue, bottom: .zero, right: AppSize.Spacing.inset.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return AppSize.Spacing.inset.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return AppSize.Spacing.inset.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 1, height: collectionView.frame.height)
    }
}

extension MoviePopularCollectionViewCell: BaseSetupView {
    func createComponents() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.moviePopularCollectionView)
    }
    
    func setupConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(AppSize.Spacing.inset.rawValue)
            make.height.equalTo(30)
            make.width.equalTo(162)
        }
        
        self.moviePopularCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }
    }
    
    func binding() {
        self.moviePopularCollectionView.rx.setDelegate(self).disposed(by: self.viewModel.disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<CustomSectionModel> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueCell(ofType: MoviePopularItemCollectionViewCell.self, indexPath: indexPath)
            cell.setViewModel(item as! MovieViewModelProtocol)
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let reusableview = collectionView.dequeueCell(ofType: LoadMoreCollectionReusableView.self, ofKind: .footer, indexPath: indexPath)
            return reusableview
        }
        
        self.viewModel.sections.bind(to: self.moviePopularCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.viewModel.disposeBag)
        
        self.moviePopularCollectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.viewModel.selectMoviePopularAction.execute(indexPath)
        }).disposed(by: self.viewModel.disposeBag)
    }
    
    func setViewModel(_ viewModel: MoviePopularViewModelProtocol) {
        self.viewModel = viewModel
    }
}

extension MoviePopularCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.kind(of: .footer) {
            self.viewModel.loadMoviePopularAction.execute(())
        }
    }
}
