//
//  RealmService.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 12/05/2022.
//

import Foundation
import RealmSwift

class RealmService {
    static let shared = RealmService()
    
    func fetch<T: Object>(ofType type: T.Type) -> [T] {
        do {
            let realm = try Realm()
            let results = realm.objects(type.self)
            return Array(results)
        } catch {
            return []
        }
    }
    
    func filter<T: Object>(ofType type: T.Type, query: String) -> [T] {
        do {
            let realm = try Realm()
            let results = realm.objects(type.self).filter(query)
            return Array(results)
        } catch {
            return []
        }
    }
    
    func getById<T: Object>(ofType type: T.Type, id: Int) -> T? {
        do{
            let realm = try Realm()
            let result = realm.objects(type.self).filter("id == %@", id).first
            return result
        } catch {
            return nil
        }
    }
    
    func add(_ object: Object) {
        do {
            let realm = try! Realm()
            try! realm.write {
                realm.add(object)
            }
        }
    }
    
    func delete(_ object: Object) {
        do {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    
    func delete<T: Object>(ofType type: T.Type) {
        do {
            let realm = try! Realm()
            let results = realm.objects(type.self)
            try! realm.write {
                realm.delete(results)
            }
        }
    }
}
