//
//  CreatePartyVC.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Firebase

class CreatePartyVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let datePicker = UIDatePicker()
    var imagePicker: UIImagePickerController!
    var imageSelected = false

    @IBOutlet weak var nameOfPartyTxtField: StyledTextField!
    @IBOutlet weak var nameOfLocationTxtField: StyledTextField!
    @IBOutlet weak var datePickerStart: UITextField!
    @IBOutlet weak var datePickerEnd: UITextField!
    @IBOutlet weak var descriptionTxtArea: UITextView!
    @IBOutlet weak var partyImage: UIImageView!
    @IBOutlet weak var partyTypeControl: UISegmentedControl!
    @IBOutlet weak var partyTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegates
        nameOfPartyTxtField.delegate = self
        nameOfLocationTxtField.delegate = self
        datePickerStart.delegate = self
        datePickerEnd.delegate = self
        descriptionTxtArea.delegate = self
        
        
        //imagePicker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true 
        imagePicker.delegate = self
        
        //datepicker
        createDatepickerStart()
        createDatepickerEnd()
    }
    
    //For keyboard to move view up when typing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // on text description, this will detect when the user hits return
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionTxtArea.resignFirstResponder()
            return false
        }
        return true
    }
    
    // finished picking the image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            partyImage.image = image
            imageSelected = true
        } else {
            print("Cody1: a valid image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // for entering the datepicker to textfield
    func createDatepickerStart() {
        datePicker.datePickerMode = .dateAndTime
        //toolbar
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishedSelectingStartTime))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerStart.inputAccessoryView = toolbar
        
        // assigning datepicker to text field
        datePickerStart.inputView = datePicker
    }
    
    func createDatepickerEnd() {
        datePicker.datePickerMode = .dateAndTime
        //toolbar
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishedSelectingEndTime))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerEnd.inputAccessoryView = toolbar
        
        // assigning datepicker to text field
        datePickerEnd.inputView = datePicker
    }
    
    // when clicking done on datepicker this will format it and place it in the text field
    @objc func finishedSelectingStartTime() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        datePickerStart.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    
    @objc func finishedSelectingEndTime() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        datePickerEnd.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }

    // creating the party
    @IBAction func createPartyBtnTapped(_ sender: Any) {
       
        guard let  partyName = nameOfPartyTxtField.text, partyName != "" else {
            return
        }
        guard let partyLocation = nameOfLocationTxtField.text, partyLocation != "" else {
            return
        }
        
        guard let partyStartTime = datePickerStart.text, partyStartTime != "" else {
            return
        }
        
        guard let partyEndTime = datePickerEnd.text, partyEndTime != "" else {
            return
        }
        
        guard let partyDescription = descriptionTxtArea.text, partyDescription != "" else {
            return
        }
        guard let image = partyImage.image, imageSelected == true else {
            print("Cody1: an image must be selected")
            return
        }
        
        // all the guards are met so dismiss view controller
         dismiss(animated: true , completion: nil )
        
        //converting image to imagedata
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.instance.REF_PARTY_IMAGES.child(imgUid).putData(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("cody1: Unable to upload image to firebase storage")
                } else {
                    print("cody1: image successfully uploaded to firebase storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    self.postToFirebase(imgUrl: downloadUrl!)
                }
            })
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let user = DataService.instance.REF_CURRENT_USER
        let userKey = user.key
        var publicParty = true
        
        switch partyTypeControl.selectedSegmentIndex {
        case 0:
            publicParty = true
        case 1:
            publicParty = false
        default:
            break
        }
        
        let party: Dictionary<String, Any> = [
            "partyName": nameOfPartyTxtField.text!,
            "partyHost": userKey,
            "partyLocation": nameOfLocationTxtField.text!,
            "partyStartTime": datePickerStart.text!,
            "partyEndTime": datePickerEnd.text!,
            "partyDescription": descriptionTxtArea.text!,
            "partyImageUrl": imgUrl,
            "publicParty": publicParty
        ]
        //create the party
        let firebaseParty = DataService.instance.REF_PARTIES.childByAutoId()
        //set the value
        firebaseParty.setValue(party)
        
        // grab key
        let partyKey = firebaseParty.key
        
        // set this party under the current user as them hosting it
        user.child("partiesHosting").child(partyKey).setValue(true)
        
        //clear out current text fields
        nameOfPartyTxtField.text = ""
        nameOfLocationTxtField.text = ""
        datePickerStart.text = ""
        datePickerEnd.text = ""
        descriptionTxtArea.text = ""
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlToggled(_ sender: UISegmentedControl) {
        switch partyTypeControl.selectedSegmentIndex {
        case 0:
            partyTypeLabel.text = "Public events are open to everyone and will be available for people swipe yes to attend."
        case 1:
            partyTypeLabel.text = "Request only events will show up publically, although a person cannot attend unless you accept their request or invite them."
        default:
            break
        }
    }
    

}
