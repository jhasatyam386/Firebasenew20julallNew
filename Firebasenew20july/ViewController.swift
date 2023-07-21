//
//  ViewController.swift
//  Firebasenew20july
//
//  Created by r84 on 20/07/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class ViewController: UIViewController {
    
    var ref : DatabaseReference!
    var ref2 : Firestore!
    

    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref2 = Firestore.firestore()
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        //addData()
        // setData()
        //allData()
        //sendOtp()
        allData()
    }
    func addData(){
        self.ref.child("student").childByAutoId().setValue(["id":text1.text!,"name":text2.text!,"email":text3.text!])
    }
    func setData(){
        ref2.collection("ios").document(text1.text!).setData(["name":text2.text!])
    
    }
    func allData(){
        Auth.auth().createUser(withEmail: text1.text!, password: text2.text!) { [self] authResult, error in
            if error == nil {
                let uid = authResult?.user.uid
                self.ref2.collection("user").document()
            }
            else {
                print(error?.localizedDescription)
            }
            
        }
    }
    func sendOtp(){
        PhoneAuthProvider.provider().verifyPhoneNumber(text1.text!, uiDelegate: nil) { [self] verificationID, error in
            if error == nil {
                print("done")
                showAlert(id: verificationID!)
            }
            else{
                print(error?.localizedDescription as Any)
            }
            
        }
    }
    func showAlert(id:String){
        let alert = UIAlertController(title: "otp", message: "enter your otp", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "ok", style: .default,handler: { _ in
            self.verifyOtp(token: id, otp: (alert.textFields?.first?.text)!)
        }))
        present(alert,animated: true)
    }
    func verifyOtp(token:String,otp:String){
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: token, verificationCode: otp)
        
        Auth.auth().signIn(with: credential){ authresult,error in
            if error == nil {
                print("ok")
            }
            else{
                print(error?.localizedDescription)
            }
        }
        
    }
    

}

