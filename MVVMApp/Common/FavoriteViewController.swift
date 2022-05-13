//
//  FavoriteViewController.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 21/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Swinject
import SnapKit

class FavoriteViewController: BaseViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.text = "Favorite"
        label.font = AppFont.getFont(fontName: .openSans_Bold, size: 22)
        return label
    }()
    
    private lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.register(ofType: MovieItemType1CollectionViewCell.self)
        return collectionView
    }()
    
    private var disposeBag: DisposeBag!
    private var viewModel: FavoriteViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createComponents()
        self.setupConstraints()
        self.binding()
        self.viewModel.loadMovieFavoriteAction.execute(())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(rgb: 0xFFFFFF)
    }
    
    deinit {
        print("deinit")
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: AppSize.Height.movieItemType1.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: .zero, bottom: 10, right: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension FavoriteViewController: BaseSetupView {
    func createComponents() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.favoriteCollectionView)
    }
    
    func setupConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(162)
            make.height.equalTo(30)
        }
        
        self.favoriteCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }
    }
    
    func binding() {
        self.favoriteCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)

        let dataSource = RxCollectionViewSectionedAnimatedDataSource<MovieSectionAnimated> { [weak self] dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueCell(ofType: MovieItemType1CollectionViewCell.self, indexPath: indexPath)
            if let movie = item.movie {
                cell.setViewModel(MovieViewModel(movie: movie,
                                                 disposeBag: Assembler.resolve(DisposeBag.self),
                                                 useCase: Assembler.resolve(MovieUseCaseProtocol.self),
                                                 navigator: Assembler.resolve(MovieNavigatorProtocol.self)))
            }
            cell.setupUI(mode: .favorite)
            cell.setDeleteButtonDisposable {
                guard let self = self else {
                    return
                }
                self.viewModel.deleteMovieFavoriteAction.execute(cell.getViewModel())
            }
            return cell
        }

        self.viewModel.sections.bind(to: self.favoriteCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)


        self.favoriteCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            self.viewModel.selectMovieFavoriteAction.execute(indexPath)
        }).disposed(by: self.disposeBag)
    }
    
    func setDisposeBag(_ disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    func setViewModel(_ viewModel: FavoriteViewModelProtocol) {
        self.viewModel = viewModel
    }
}
