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
    
    init(displayName: String, email: String, userId: String, dateCreated: Date) {
        self.displayName = displayName
        self.email = email
        self.userId = userId
        self.dateCreated = dateCreated
    }
    
    class func parseData(snapshot: DocumentSnapshot?) -> User {
        var user = User(displayName: "", email: "", userId: "", dateCreated: Date())
        guard let snap = snapshot else { return user }
        
            let displayName = snap.get(DISPLAY_NAME) as? String ?? ""
            let email = snap.get(EMAIL) as? String ?? ""
            let userId = snap.get(USER_ID) as? String ?? ""
            let dateCreated = snap.get(DATE_CREATED) as? Date ?? Date()

        user = User(displayName: displayName, email: email, userId: userId, dateCreated: dateCreated)
        return user
    }
    
}
