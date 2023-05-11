//
//  NoteService.swift
//  CustomLogin
//
//  Created by YE002 on 22/04/23.
//
import Foundation
import FirebaseFirestore

struct NoteService {
    
    static let db = Firestore.firestore()
    
    static func addingNote(documentID: String , data: [String : Any], completion: @escaping (Error?) -> (Void)){
        
        db.collection("notes").document(documentID).setData(data){ error in
            completion(error)
        }
    }
    
    static func updatingNote(newData: [String : Any] , id: String , completion: @escaping (Error?) -> (Void)){
        db.collection("notes").document(id).setData(newData){ error in
            completion(error)
        }
    }
    
    static func deletingNote( id: String , completion: @escaping (Error?) -> (Void)){
            db.collection("notes").document(id).updateData(["isDeleted" : true]){ error in
                completion(error)
            }
     }
    
    static func deletingNoteinFB( id: String , completion: @escaping (Error?) -> (Void)){
            db.collection("notes").document(id).delete(){ error in
                completion(error)
            }
     }
    
}
