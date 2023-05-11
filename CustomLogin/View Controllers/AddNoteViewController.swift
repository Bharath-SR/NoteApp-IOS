//
//  AddNoteViewController.swift
//  CustomLogin
//
//  Created by YE002 on 22/04/23.
//

import UIKit
import UserNotifications


class AddNoteViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleDescField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorFromHex("#C7417B")
        navigationControllerBar()

    }

    @objc func addNote(){

        guard let title = titleTextField.text , let description = titleDescField.text else{ return }

        let documentID = String((NSDate.init().timeIntervalSince1970)*1000)

        let data: [String: Any] = ["title":title ,"description":description, "id":documentID]

        isAdded = true

        NoteService.addingNote(documentID: documentID, data: data) { error in
            if error != nil{
                return
            }
            self.navigationController?.popViewController(animated: true)

        }

    }


    func navigationControllerBar(){
        let notes = UIBarButtonItem(image: UIImage.init(systemName: "note.text.badge.plus"), style: .plain, target: self, action: #selector(addNote) )
        let share = UIBarButtonItem(image: UIImage.init(systemName: "alarm"), style: .plain, target: self, action: #selector(remainder))
        navigationItem.rightBarButtonItems = [share, notes]
        navigationController?.navigationBar.barTintColor =  UIColor.colorFromHex("#C7417B")
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Notes"
        navigationItem.rightBarButtonItem?.tintColor = .black



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
                        content.body = self.titleDescField.text!

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


}


