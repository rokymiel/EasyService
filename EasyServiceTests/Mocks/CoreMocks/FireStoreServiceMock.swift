//
//  FireStoreServiceMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 29.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import Firebase
// swiftlint:disable force_cast

class FireStoreServiceMock: IFireStoreService {
    
    var invokedAddDocumentFrom = false
    var invokedAddDocumentFromCount = 0
    var invokedAddDocumentFromParameters: (value: Any, Void)?
    var invokedAddDocumentFromParametersList = [(value: Any, Void)]()
    var stubbedAddDocumentFromResult: DocumentReference!
    
    func addDocument<T>(from value: T) -> DocumentReference? where T: Encodable {
        invokedAddDocumentFrom = true
        invokedAddDocumentFromCount += 1
        invokedAddDocumentFromParameters = (value, ())
        invokedAddDocumentFromParametersList.append((value, ()))
        return stubbedAddDocumentFromResult
    }
    
    var invokedAddDocumentWith = false
    var invokedAddDocumentWithCount = 0
    var invokedAddDocumentWithParameters: (id: String, value: Any)?
    var invokedAddDocumentWithParametersList = [(id: String, value: Any)]()
    
    func addDocument<T>(with id: String, from value: T) where T: Encodable {
        invokedAddDocumentWith = true
        invokedAddDocumentWithCount += 1
        invokedAddDocumentWithParameters = (id, value)
        invokedAddDocumentWithParametersList.append((id, value))
    }
    
    var invokedAddDocumentOf = false
    var invokedAddDocumentOfCount = 0
    var invokedAddDocumentOfParameters: (document: String, collection: String, id: String, value: Any)?
    var invokedAddDocumentOfParametersList = [(document: String, collection: String, id: String, value: Any)]()
    
    func addDocument<T>(of document: String, to collection: String, with id: String, from value: T) where T: Encodable {
        invokedAddDocumentOf = true
        invokedAddDocumentOfCount += 1
        invokedAddDocumentOfParameters = (document, collection, id, value)
        invokedAddDocumentOfParametersList.append((document, collection, id, value))
    }
    
    var invokedRemoveDocument = false
    var invokedRemoveDocumentCount = 0
    var invokedRemoveDocumentParameters: (document: String, collection: String, id: String)?
    var invokedRemoveDocumentParametersList = [(document: String, collection: String, id: String)]()
    
    func removeDocument(of document: String, to collection: String, with id: String) {
        invokedRemoveDocument = true
        invokedRemoveDocumentCount += 1
        invokedRemoveDocumentParameters = (document, collection, id)
        invokedRemoveDocumentParametersList.append((document, collection, id))
    }
    
    var invokedLoadDocumentsResultTErrorVoid = false
    var invokedLoadDocumentsResultTErrorVoidCount = 0
    var stubbedLoadDocumentsResultTErrorVoidCompletionResult: (Result<[Any], Error>, Void)?
    
    func loadDocuments<T>(_ completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
        invokedLoadDocumentsResultTErrorVoid = true
        invokedLoadDocumentsResultTErrorVoidCount += 1
        if let result = stubbedLoadDocumentsResultTErrorVoidCompletionResult {
            switch result.0 {
            case .success(let array):
                completion(.success(array as! [T]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    var invokedLoadDocumentsResulttypeDocumentChangeTypeitemTErrorVoid = false
    var invokedLoadDocumentsResulttypeDocumentChangeTypeitemTErrorVoidCount = 0
    var stubbedLoadDocumentsResulttypeDocumentChangeTypeitemTErrorVoidCompletionResult: (Result<[(type: DocumentChangeType, item: Any?)], Error>, Void)?
    var stubbedLoadDocumentsResulttypeDocumentChangeTypeitemTErrorVoidResult: ListenerRegistration!
    
    func loadDocuments<T>(_ completion: @escaping (Result<[(type: DocumentChangeType, item: T?)], Error>) -> Void) -> ListenerRegistration where T: Decodable {
        invokedLoadDocumentsResulttypeDocumentChangeTypeitemTErrorVoid = true
        invokedLoadDocumentsResulttypeDocumentChangeTypeitemTErrorVoidCount += 1
        if let result = stubbedLoadDocumentsResulttypeDocumentChangeTypeitemTErrorVoidCompletionResult {
            switch result.0 {
            case .success(let res):
                completion(.success(res.map { ($0.type, $0.item as? T) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return stubbedLoadDocumentsResulttypeDocumentChangeTypeitemTErrorVoidResult
    }
    
    var invokedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoid = false
    var invokedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoidCount = 0
    var invokedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoidParameters: (field: String, value: Any)?
    var invokedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoidParametersList = [(field: String, value: Any)]()
    var stubbedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoidCompletionResult: (Result<[Any], Error>, Void)?
    
    func loadDocuments<T>(where field: String, isEqualTo value: Any, _ completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
        invokedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoid = true
        invokedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoidCount += 1
        invokedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoidParameters = (field, value)
        invokedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoidParametersList.append((field, value))
        if let result = stubbedLoadDocumentsWhereStringIsEqualToAnyResultTErrorVoidCompletionResult {
            switch result.0 {
            case .success(let array):
                completion(.success(array as! [T]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    var invokedLoadDocumentsWhereStringAnyResultTErrorVoid = false
    var invokedLoadDocumentsWhereStringAnyResultTErrorVoidCount = 0
    var invokedLoadDocumentsWhereStringAnyResultTErrorVoidParameters: (fields: [String: [Any]], Void)?
    var invokedLoadDocumentsWhereStringAnyResultTErrorVoidParametersList = [(fields: [String: [Any]], Void)]()
    var stubbedLoadDocumentsWhereStringAnyResultTErrorVoidCompletionResult: (Result<[Any], Error>, Void)?
    
    func loadDocuments<T>(where fields: [String: [Any]], _ completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
        invokedLoadDocumentsWhereStringAnyResultTErrorVoid = true
        invokedLoadDocumentsWhereStringAnyResultTErrorVoidCount += 1
        invokedLoadDocumentsWhereStringAnyResultTErrorVoidParameters = (fields, ())
        invokedLoadDocumentsWhereStringAnyResultTErrorVoidParametersList.append((fields, ()))
        if let result = stubbedLoadDocumentsWhereStringAnyResultTErrorVoidCompletionResult {
            switch result.0 {
            case .success(let array):
                completion(.success(array as! [T]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    var invokedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoid = false
    var invokedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidCount = 0
    var invokedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidParameters: (fields: [String: [Any]], Void)?
    var invokedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidParametersList = [(fields: [String: [Any]], Void)]()
    var stubbedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidCompletionResult: (Result<[(type: DocumentChangeType, item: Any?)], Error>, Void)?
    var stubbedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidResult: ListenerRegistration!
    
    func loadDocuments<T>(where fields: [String: [Any]],
                          _ completion: @escaping (Result<[(type: DocumentChangeType, item: T?)], Error>) -> Void)
    -> ListenerRegistration? where T: Decodable {
        invokedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoid = true
        invokedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidCount += 1
        invokedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidParameters = (fields, ())
        invokedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidParametersList.append((fields, ()))
        if let result = stubbedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidCompletionResult {
            switch result.0 {
            case .success(let res):
                completion(.success(res.map { ($0.type, $0.item as? T) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return stubbedLoadDocumentsWhereStringAnyResulttypeDocumentChangeTypeitemTErrorVoidResult
    }
    
    var invokedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoid = false
    var invokedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidCount = 0
    var invokedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidParameters: (field: String, value: Any)?
    var invokedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidParametersList = [(field: String, value: Any)]()
    var stubbedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidCompletionResult: (Result<[(type: DocumentChangeType, item: Any?)], Error>, Void)?
    var stubbedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidResult: ListenerRegistration!
    
    func loadDocuments<T>(where field: String,
                          isEqualTo value: Any,
                          _ completion: @escaping (Result<[(type: DocumentChangeType, item: T?)], Error>) -> Void)
    -> ListenerRegistration where T: Decodable {
        invokedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoid = true
        invokedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidCount += 1
        invokedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidParameters = (field, value)
        invokedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidParametersList.append((field, value))
        if let result = stubbedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidCompletionResult {
            switch result.0 {
            case .success(let res):
                completion(.success(res.map { ($0.type, $0.item as? T) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return stubbedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidResult
    }
    
    var invokedLoadDocumentIdString = false
    var invokedLoadDocumentIdStringCount = 0
    var invokedLoadDocumentIdStringParameters: (id: String, Void)?
    var invokedLoadDocumentIdStringParametersList = [(id: String, Void)]()
    var stubbedLoadDocumentIdStringCompletionResult: (Result<Any, Error>, Void)?
    
    func loadDocument<T>(id: String, _ completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        invokedLoadDocumentIdString = true
        invokedLoadDocumentIdStringCount += 1
        invokedLoadDocumentIdStringParameters = (id, ())
        invokedLoadDocumentIdStringParametersList.append((id, ()))
        if let result = stubbedLoadDocumentIdStringCompletionResult {
            switch result.0 {
            case .success(let item):
                completion(.success(item as! T))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    var invokedLoadDocumentIdListener = false
    var invokedLoadDocumentIdListenerCount = 0
    var invokedLoadDocumentIdListenerParameters: (id: String, Void)?
    var invokedLoadDocumentIdListenerParametersList = [(id: String, Void)]()
    var stubbedLoadDocumentIdListenerListenerResult: (Result<Any, Error>, Void)?
    var stubbedLoadDocumentIdListenerResult: ListenerRegistration!
    
    func loadDocument<T>(id: String, listener: @escaping (Result<T, Error>) -> Void) -> ListenerRegistration where T: Decodable {
        invokedLoadDocumentIdListener = true
        invokedLoadDocumentIdListenerCount += 1
        invokedLoadDocumentIdListenerParameters = (id, ())
        invokedLoadDocumentIdListenerParametersList.append((id, ()))
        if let result = stubbedLoadDocumentIdListenerListenerResult {
            switch result.0 {
            case .success(let item):
                listener(.success(item as! T))
            case .failure(let error):
                listener(.failure(error))
            }
            
        }
        return stubbedLoadDocumentIdListenerResult
    }
    
    var invokedAddDocumentData = false
    var invokedAddDocumentDataCount = 0
    var invokedAddDocumentDataParameters: (data: [String: Any], Void)?
    var invokedAddDocumentDataParametersList = [(data: [String: Any], Void)]()
    
    func addDocument(data: [String: Any]) {
        invokedAddDocumentData = true
        invokedAddDocumentDataCount += 1
        invokedAddDocumentDataParameters = (data, ())
        invokedAddDocumentDataParametersList.append((data, ()))
    }
}
