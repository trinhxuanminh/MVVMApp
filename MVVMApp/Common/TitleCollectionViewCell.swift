//
//  TitleCollectionViewCell.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 25/04/2022.
//

import Foundation
import UIKit
import SnapKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    enum Mode: String {
        case nowPlaying = "Now Playing"
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.font = AppFont.getFont(fontName: .openSans_Bold, size: 22)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createComponents()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleCollectionViewCell: BaseSetupView {
    func createComponents() {
        self.contentView.addSubview(self.titleLabel)
    }
    
    func setupConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(AppSize.Spacing.inset.rawValue)
        }
    }
    
    func binding() {
    }
    
    func setupUI(mode: Mode) {
        self.titleLabel.text = mode.rawValue
    }
}
