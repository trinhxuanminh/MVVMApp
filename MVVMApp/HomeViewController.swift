//
//  HomeViewController.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Swinject
import SnapKit

class HomeViewController: BaseViewController {
    
    private lazy var homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.register(ofType: MoviePopularCollectionViewCell.self)
        collectionView.register(ofType: MovieItemType1CollectionViewCell.self)
        collectionView.register(ofType: ShowFavoriteCollectionViewCell.self)
        collectionView.register(ofType: TitleCollectionViewCell.self)
        return collectionView
    }()
    
    private var disposeBag: DisposeBag!
    private var viewModel: HomeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createComponents()
        self.setupConstraints()
        self.binding()
        self.viewModel.loadMovieNowPlayingAction.execute(())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(rgb: 0xFFFFFF)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                return CGSize(width: collectionView.frame.width, height: AppSize.Height.moviePopularList.rawValue)
            case 1:
                return CGSize(width: collectionView.frame.width, height: AppSize.Height.showFavorite.rawValue)
            default:
                return CGSize(width: collectionView.frame.width, height: AppSize.Height.title.rawValue)
            }
        default:
            return CGSize(width: collectionView.frame.width, height: AppSize.Height.movieItemType1.rawValue)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 16, left: .zero, bottom: .zero, right: .zero)
        default:
            return UIEdgeInsets(top: 16, left: .zero, bottom: 10, right: .zero)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension HomeViewController: BaseSetupView {
    func createComponents() {
        self.view.addSubview(self.homeCollectionView)
    }
    
    func setupConstraints() {
        self.homeCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func binding() {
        self.homeCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<CustomSectionModel> { dataSource, collectionView, indexPath, item in
            switch indexPath.section {
            case 0:
                switch indexPath.item {
                case 0:
                    let cell = collectionView.dequeueCell(ofType: MoviePopularCollectionViewCell.self, indexPath: indexPath)
                    cell.setViewModel(Assembler.resolve(MoviePopularViewModelProtocol.self))
                    return cell
                case 1:
                    let cell = collectionView.dequeueCell(ofType: ShowFavoriteCollectionViewCell.self, indexPath: indexPath)
                    cell.setViewModel(Assembler.resolve(ShowFavoriteViewModelProtocol.self))
                    return cell
                default:
                    let cell = collectionView.dequeueCell(ofType: TitleCollectionViewCell.self, indexPath: indexPath)
                    cell.setupUI(mode: .nowPlaying)
                    return cell
                }
            default:
                let cell = collectionView.dequeueCell(ofType: MovieItemType1CollectionViewCell.self, indexPath: indexPath)
                cell.setViewModel(item as! MovieViewModelProtocol)
                cell.setupUI(mode: .movieNowPlaying)
                return cell
            }
        }
        
        self.viewModel.sections.bind(to: self.homeCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        self.homeCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            self.viewModel.selectMovieNowPlayingAction.execute(indexPath)
        }).disposed(by: self.disposeBag)
    }
    
    func setDisposeBag(_ disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    func setViewModel(_ viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
    }
}
