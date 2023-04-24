//
//  DialogBoxPopupViewController.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 24/04/23.
//

import UIKit

class DialogBoxPopupViewController: UIViewController {
        
    @IBOutlet weak var dialogBoxView: UIView!
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var content: String?

    
    //MARK:- lifecyle methods for the view controller
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //adding an overlay to the view to give focus to the dialog box
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)

        //customizing the dialog box view
        dialogBoxView.layer.cornerRadius = 6.0
        dialogBoxView.layer.borderWidth = 1.2
        dialogBoxView.layer.borderColor = UIColor.lightGray.cgColor
        
        //customizing the okay button
        okayButton.backgroundColor = .darkGray.withAlphaComponent(0.85)
        okayButton.setTitleColor(UIColor.white, for: .normal)
        okayButton.layer.cornerRadius = 4.0
        okayButton.layer.borderWidth = 1.2
        okayButton.layer.borderColor = UIColor.darkGray.cgColor
        
        descriptionLabel.text = content
    }
    
    //MARK:- outlet functions for the viewController
    @IBAction func okayButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- functions for the viewController
    static func showPopup(parentVC: UIViewController, content: String){
        if let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DialogBoxPopupViewController") as? DialogBoxPopupViewController {
            popupViewController.content = content
            popupViewController.modalPresentationStyle = .custom
            popupViewController.modalTransitionStyle = .crossDissolve
            parentVC.present(popupViewController, animated: true)
        }
    }
}
