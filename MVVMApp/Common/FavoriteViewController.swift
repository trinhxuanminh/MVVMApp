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

class FavoriteViewController: BaseViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.text = "Favorite"
        label.font = AppFont.getFont(fontName: .openSans_Bold, size: 22)
        return label
    }()
    
    private lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 162),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.favoriteCollectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.favoriteCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.favoriteCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.favoriteCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func binding() {
        self.favoriteCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)

        let dataSource = RxCollectionViewSectionedReloadDataSource<CustomSectionModel> { [weak self] dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueCell(ofType: MovieItemType1CollectionViewCell.self, indexPath: indexPath)
            cell.setViewModel(item as! MovieViewModelProtocol)
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
