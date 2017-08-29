//
//  DashboardVC.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class DashboardVC: UIViewController {

    @IBOutlet weak var myPartiesBtn: UIButton!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var partyTitleLbl: UILabel!
    @IBOutlet weak var partyTimeLbl: UILabel!
    @IBOutlet weak var partyCityLbl: UILabel!
    @IBOutlet weak var partyImage: UIImageView!
    @IBOutlet weak var partyCard: RoundedView!
    
    //for swipe effect
    var divisor: CGFloat!
    var xCenter: CGFloat!
    var yCenter: CGFloat!
    
    var parties = [Party]()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //math for swiping card
        xCenter = partyCard.center.x
        yCenter = partyCard.center.y
        divisor = (view.frame.width / 2) / 0.61
        
        //grabbing the data from firebase
        self.retrieveParties()
        
        // for SWREVEAL
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Tap back to close
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        myPartiesBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)

    }
    
    func reinitializeData() {
        showData()
    }
    
    func retrieveParties() {
        DataService.instance.REF_PARTIES.observe(.value, with: { (snapshot) in
            //clear out posts so you dont get duplicates
            self.parties = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print( "Snap: \(snap)")
                    if let partyDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let party = Party(partyKey: key, partyData: partyDict)
                        self.parties.append(party)
                        // this will download and cache images before user reaches photo, making a better user experience
                        self.showData()
                    }
                }
            }
        })
    }
    
    // index increases, which then grabs new item from array above and shows new info
    func showData() {
        if parties.count > 0 {
            index += 1
            if ( index < parties.count) {
                let partyName = parties[index].partyName
                let partyLocation = parties[index].partyLocation
                let partyDate = parties[index].partyStartTime
                
                //updating labels
                partyTitleLbl.text = partyName
                partyCityLbl.text = partyLocation
                partyTimeLbl.text = partyDate
                
                let imageUrl = URL(string: parties[index].partyImageUrl)!
                print("downloading or caching image")
                self.partyImage.kf.setImage(with: imageUrl)
                
            } else {
                // THIS IS JUST HERE FOR TESTING, IT SHOULD CHANGE TO ANIMATION 
                index = 0
                let partyName = parties[index].partyName
                let partyLocation = parties[index].partyLocation
                let partyDate = parties[index].partyStartTime
                
                //updating labels
                partyTitleLbl.text = partyName
                partyCityLbl.text = partyLocation
                partyTimeLbl.text = partyDate
            
                let imageUrl = URL(string: parties[index].partyImageUrl)!
                print("downloading or caching image")
                self.partyImage.kf.setImage(with: imageUrl)
            }
            
        }
    }

    @IBAction func panCardTapped(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y )
        
        let scale = min(100/abs(xFromCenter), 1)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        
                if xFromCenter > 0 {
                    ratingImageView.image = #imageLiteral(resourceName: "like")
                    ratingImageView.tintColor = UIColor.white
                    ratingImageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5460222271)
                } else {
                    ratingImageView.image = #imageLiteral(resourceName: "dislike")
                    ratingImageView.tintColor = UIColor.white
                    ratingImageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.55)
                }
        
                ratingImageView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizerState.ended {
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x, y: card.center.y + 75)
                    card.alpha = 0
                })
                delay(0.3) {
                    // user has swiped far left so reload a new card
                    self.loadNewCard()
                }
                return
            } else if card.center.x > (view.frame.width - 75) {
                print("index her it is  \(index)")
                // perform segue
                //performSegue(withIdentifier: GO_TO_CREATE_OFFER_VC, sender: self)
                
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75 )
                    card.alpha = 0
                })
                delay(0.3) {
                    // user has swiped far right so reload a new card
                    self.loadNewCard()
                    self.performSegue(withIdentifier: GO_TO_SEND_PARTY_REQUEST_VC, sender: nil)
                }
                return
            }
            // the user didn't completely swipe left or right so just reset the card
            resetCard()
        }
    }
    
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    func loadNewCard() {
        // resetting to initial spot the below l
        self.partyCard.center = self.view.center
        self.ratingImageView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.partyCard.alpha = 1
            self.partyCard.transform = CGAffineTransform.identity
        })
        reinitializeData()

    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.partyCard.center = self.view.center
            self.ratingImageView.alpha = 0
            self.partyCard.alpha = 1
            self.partyCard.transform = CGAffineTransform.identity
        })
    }
    

}
