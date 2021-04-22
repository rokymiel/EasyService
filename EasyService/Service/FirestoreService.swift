//
//  FirestoreService.swift
//  EasyService
//
//  Created by Михаил on 08.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift

protocol IFireStoreService: class {
    func addDocument(data: [String: Any])
    func addDocument<T>(from value: T) -> DocumentReference? where T: Encodable
    func addDocument<T>(with id: String, from value: T) where T: Encodable
    
    func loadDocuments<T>(_ completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable
    
    func loadDocuments<T>(_ completion: @escaping (Result<[(type: DocumentChangeType, item: T?)], Error>) -> Void) where T: Decodable
    
    func loadDocuments<T>(where field: String, isEqualTo value: Any, _ completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable
    
    func loadDocuments<T>(where field: String, isEqualTo value: Any, _ completion: @escaping (Result<[(type: DocumentChangeType, item: T?)], Error>) -> Void) where T: Decodable
    func loadDocument<T>(id: String, _ completion: @escaping (Result<T, Error>) -> Void) where T: Decodable
    func loadDocument<T>(id: String, listener: @escaping (Result<T, Error>) -> Void) where T: Decodable
    func loadDocuments<T>(where fields: [String: [Any]], _ completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable
    func loadDocuments<T>(where fields: [String: [Any]], _ completion: @escaping (Result<[(type: DocumentChangeType, item: T?)], Error>) -> Void) where T: Decodable
}

final class FireStoreService: IFireStoreService {
    func addDocument<T>(from value: T) -> DocumentReference? where T: Encodable {
        return try? reference.addDocument(from: value)
    }
    
    func addDocument<T>(with id: String, from value: T) where T: Encodable {
        print("SSSAAAVVV")
        do {try reference.document(id).setData(from: value)} catch {
            print(error)
        }
    }
    
    func loadDocuments<T>(_ completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
        reference.getDocuments { snapshot, error in
            if let error = error {
                return completion(.failure(error))
            }
            if let services = snapshot?.documents.compactMap({ try? $0.data(as: T.self) }) {
                completion(.success(services))
            }
        }
    }
    
    func loadDocuments<T>(_ completion: @escaping (Result<[(type: DocumentChangeType, item: T?)], Error>) -> Void) where T: Decodable {
        
        reference.addSnapshotListener { snapshot, error in
            if let error = error {
                return completion(.failure(error))
            }
            if let documents = snapshot?.documentChanges {
                completion(.success(documents.map( {(type: $0.type, item: try? $0.document.data(as: T.self))})))
            }
        }
    }
    
    func loadDocuments<T>(where field: String, isEqualTo value: Any, _ completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
        reference.whereField(field, isEqualTo: value).getDocuments { snapshot, error in
            if let error = error {
                return completion(.failure(error))
            }
            if let services = snapshot?.documents.compactMap({ try? $0.data(as: T.self) }) {
                completion(.success(services))
            }
        }
    }
    
    func loadDocuments<T>(where fields: [String: [Any]], _ completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
        guard !fields.isEmpty else {
            return
        }
        var query: Query = reference
        for (key, value) in fields {
            query = query.whereField(key, in: value)
        }
        query.getDocuments { snapshot, error in
            if let error = error {
                return completion(.failure(error))
            }
            if let services = snapshot?.documents.compactMap({ try? $0.data(as: T.self) }) {
                completion(.success(services))
            }
        }
    }
    
    func loadDocuments<T>(where fields: [String: [Any]], _ completion: @escaping (Result<[(type: DocumentChangeType, item: T?)], Error>) -> Void) where T: Decodable {
        
        guard !fields.isEmpty else {
            return
        }
        var query: Query = reference
        for (key, value) in fields {
            query = query.whereField(key, in: value)
        }
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                return completion(.failure(error))
            }
            if let documents = snapshot?.documentChanges {
                completion(.success(documents.map( {(type: $0.type, item: try? $0.document.data(as: T.self))})))
            }
        }
    }
    
    func loadDocuments<T>(where field: String, isEqualTo value: Any, _ completion: @escaping (Result<[(type: DocumentChangeType, item: T?)], Error>) -> Void) where T: Decodable {
        
        reference.whereField(field, isEqualTo: value).addSnapshotListener { snapshot, error in
            if let error = error {
                return completion(.failure(error))
            }
            if let documents = snapshot?.documentChanges {
                completion(.success(documents.map( {(type: $0.type, item: try? $0.document.data(as: T.self))})))
            }
        }
    }
    
    func loadDocument<T>(id: String, _ completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        reference.document(id).getDocument { snapshot, error in
            if let error = error {
                return completion(.failure(error))
            }
            if let snapshot = snapshot, let item = try? snapshot.data(as: T.self) {
                completion(.success(item))
            }
        }
    }
    
    func loadDocument<T>(id: String, listener: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        print("Id",id)
        reference.document(id).addSnapshotListener { snapshot, error in
            print("CC")
            if let error = error {
                print(error)
                return listener(.failure(error))
            }
            if let snapshot = snapshot, let item = try? snapshot.data(as: T.self) {
                print(item)
                listener(.success(item))
            } else {
                print("Lox")
                print(snapshot?.data())
            }
            
        }
    }
    
    let reference: CollectionReference
    
    init(reference: CollectionReference) {
        self.reference = reference
    }
    
    func addDocument(data: [String: Any]) {
        reference.addDocument(data: data)
    }
}
