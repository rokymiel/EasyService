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
    func addDocument<T: Encodable>(from value: T) -> DocumentReference?
    func loadDocuments<T: Decodable>(_ compilation: @escaping (Result<[T], Error>) -> Void)
}

final class FireStoreService: IFireStoreService {
    func addDocument<T>(from value: T) -> DocumentReference? where T : Encodable {
         return try? reference.addDocument(from: value)
    }
    
    func loadDocuments<T>(_ compilation: @escaping (Result<[T], Error>) -> Void) where T : Decodable {
         reference.getDocuments { snapshot, error in
            if let error = error {
                return compilation(.failure(error))
            }
            for d in snapshot!.documents {
                print(d.data())
                print(d.data()["work_time"] as? [String: Any])
                print(try? d.data(as: T.self))
                print(try? d.data(as: Service.self))
            }
            
            if let services = snapshot?.documents.compactMap({ try? $0.data(as: T.self) }) {
                compilation(.success(services))
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
