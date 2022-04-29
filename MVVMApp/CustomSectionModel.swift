//
//  SectionOfCustomData.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import RxDataSources

struct CustomSectionModel {
    var header: String?
    var footer: String?
    var items: [Any?]
}

extension CustomSectionModel: SectionModelType {
    typealias Item = Any?
    
    init(original: CustomSectionModel, items: [Any?]) {
        self = original
        self.items = items
    }
}
