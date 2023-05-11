//
//  Remainder.swift
//  CustomLogin
//
//  Created by YE002 on 25/04/23.
//

import Foundation
import UIKit
class Reminder: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    public var completion : ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(SaveButton))
    }
    
    @objc func SaveButton(){
        let targetDate = datePicker.date
        completion?(targetDate)
        navigationController?.popViewController(animated: true)
    }
    
    func navigationControllerBar(){
        
        navigationController?.navigationBar.barTintColor = .systemBlue
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title : "Add" , style: .plain, target: self, action: #selector(SaveButton))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
}
