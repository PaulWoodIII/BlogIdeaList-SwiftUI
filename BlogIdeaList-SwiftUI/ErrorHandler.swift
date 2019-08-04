//
//  ContentView.swift
//  BlogIdeaList-SwiftUI
//
//  Created by Andrew Bancroft on 7/30/19.
//  Copyright © 2019 Andrew Bancroft. All rights reserved.
//
// ❇️ Alerts you to Core Data pieces
// ℹ️ Alerts you to general info about what my brain was thinking when I wrote the code
//

import Foundation
import SwiftUI

enum ErrorHandler: Identifiable {
    
    // ℹ️ makes each new instance unique
    var id: UUID { UUID() }
    
    // ℹ️ Our only case but we can extend this enum to offer the user a choice on which Object to
    // keep if a merge conflict occurs
    case displayError(_: Error)
    
    static func actionSheet(for type: ErrorHandler) -> ActionSheet {
        return ActionSheet(title: type.title,
                           message: type.message,
                           buttons: type.buttons)
    }
    
    var title: Text {
        return Text("Error")
    }
    
    var message: Text? {
        switch self {
        case .displayError(let err):
            return Text(err.localizedDescription)
        }
    }
    
    var buttons: [ActionSheet.Button] {
        return [.default(Text("OK"))]
    }
}
