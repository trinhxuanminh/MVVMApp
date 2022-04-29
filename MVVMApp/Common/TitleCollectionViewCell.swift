//
//  TitleCollectionViewCell.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 25/04/2022.
//

import Foundation
import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    enum Mode: String {
        case nowPlaying = "Now Playing"
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: AppSize.Spacing.inset.rawValue),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -AppSize.Spacing.inset.rawValue),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func binding() {
    }
    
    func setupUI(mode: Mode) {
        self.titleLabel.text = mode.rawValue
    }
}
