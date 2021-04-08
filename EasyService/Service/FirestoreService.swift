//
//  FirestoreService.swift
//  EasyService
//
//  Created by Михаил on 08.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift

protocol IFireStoreService {
    func addDocument(data: [String: Any])
    func addDocument<T: Encodable>(from value: T) -> DocumentReference?
}

final class FireStoreService: IFireStoreService {
    
    let reference: CollectionReference
    
    init(reference: CollectionReference) {
        self.reference = reference
    }
    
    func addDocument(data: [String : Any]) {
        reference.addDocument(data: data)
    }
    func addDocument<T: Encodable>(from value: T) -> DocumentReference? {
         return try? reference.addDocument(from: value)
    }
}
