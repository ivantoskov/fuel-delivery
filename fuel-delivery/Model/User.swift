//
//  User.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 01/12/2020.
//

import Foundation
import Firebase

class User {
    
    private(set) var displayName: String!
    private(set) var email: String!
    private(set) var userId: String!
    private(set) var dateCreated: Date!
    private(set) var rating: Int!
    
    init(displayName: String, email: String, userId: String, dateCreated: Date, rating: Int) {
        self.displayName = displayName
        self.email = email
        self.userId = userId
        self.dateCreated = dateCreated
        self.rating = rating
    }
    
    class func parseData(snapshot: DocumentSnapshot?) -> User {
        var user = User(displayName: "", email: "", userId: "", dateCreated: Date(), rating: 0)
        guard let snap = snapshot else { return user }
        
            let displayName = snap.get(DISPLAY_NAME) as? String ?? ""
            let email = snap.get(EMAIL) as? String ?? ""
            let userId = snap.documentID
            let dateCreated = snap.get(DATE_CREATED) as? Date ?? Date()
            let rating = snap.get(RATING) as? Int ?? 0

        user = User(displayName: displayName, email: email, userId: userId, dateCreated: dateCreated, rating: rating)
        return user
    }
}
