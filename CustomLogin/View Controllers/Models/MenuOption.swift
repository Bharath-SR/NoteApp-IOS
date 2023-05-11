//
//  MenuOption.swift
//  SideMenu
//
//  Created by YE002 on 12/04/23.
//

import UIKit
enum MenuOption: Int , CustomStringConvertible{
    
    case Inbox
    case Notification
    case Trash
    case Logout
    
    var description : String{
        switch self {
            
        case .Inbox:
            return "Inbox"
        case .Notification:
            return "Notification"
        case .Trash:
            return "Trash"
        case .Logout:
            return "Logout"
        }
        
    }
 
    var image: UIImage {
        switch self {
        
        case .Inbox:
            return UIImage(systemName: "message.fill") ?? UIImage()
        case .Notification:
            return UIImage(systemName: "bell.fill") ?? UIImage()
        case .Trash:
            return UIImage(systemName: "gearshape.fill") ?? UIImage()
        case .Logout:
            return UIImage(systemName: "iphone.and.arrow.forward" ) ?? UIImage()
    
        }
    }
}
