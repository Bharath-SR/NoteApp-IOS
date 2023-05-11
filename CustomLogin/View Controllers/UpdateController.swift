//
//  UpdateController.swift
//  CustomLogin
//
//  Created by YE002 on 22/04/23.
//
import UIKit
import UserNotifications

class UpdateController : UIViewController{
    
    var selectedNote : Note?
 
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = selectedNote?.title
        descriptionTextField.text = selectedNote?.description
        configureNavigationController()
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        
        if let title = titleTextField.text , let description = descriptionTextField.text , let id = selectedNote?.id{
            
            
            let newData :[String : Any] = ["title":title , "description": description  , "id": id]
            
            NoteService.updatingNote(newData: newData, id: id){  error in
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                    
                }
                
                else{
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }  
                
            }
        }
        
        
    }
    
    @objc func deleteNote(){
        
        var popUpWindow: PopUpWindow!
        popUpWindow = PopUpWindow(title: "Alert!", text: "Your Note Has Been Deleted", buttontext: "OK")
        self.present(popUpWindow, animated: true, completion: nil)
        
        if let id = selectedNote?.id {
            NoteService.deletingNote(id: id) {error in
                if error != nil{
                    return
                }
                
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func remainder() {
        guard let addReminderController = storyboard?.instantiateViewController(identifier:"Reminder") as? Reminder else {
            return
        }
        
        
        navigationController?.pushViewController(addReminderController, animated: true)
        addReminderController.title = "Set Reminder"
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge, .sound],completionHandler:  { success, error in
            if success {
                //schedule test
                
                addReminderController.completion = { date in
                    DispatchQueue.main.async {
                        
                        
                        //content
                        let content = UNMutableNotificationContent()
                        
                        content.title = self.titleTextField.text!
                        content.sound = .default
                        content.body = self.descriptionTextField.text!
                        
                        //trigger
                        let targetDate = date
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month , .day , .hour , .minute , .second], from: targetDate), repeats: false)
                        
                        //request
                        
                        let request = UNNotificationRequest(identifier: "some_id", content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { error in
                            if error != nil{
                                print("Something went wrong")
                            }
                        }
                    }
                }
                
                
            }else if let error = error {
                print("Error occured")
            }
        })
    }
    func configureNavigationController(){
        
        let delete = UIBarButtonItem(image: UIImage.init(systemName: "trash"), style: .plain, target: self, action: #selector(deleteNote))
        let share = UIBarButtonItem(image: UIImage.init(systemName: "alarm"), style: .plain, target: self, action: #selector(remainder))
        navigationItem.rightBarButtonItems = [share, delete]
        navigationController?.navigationBar.barTintColor = UIColor.colorFromHex("#C7417B")
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Update"
        navigationItem.rightBarButtonItem?.tintColor = .black
        
    }
  
}
