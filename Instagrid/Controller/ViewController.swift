//
//  ViewController.swift
//  Instagrid
//
//  Created by Ludovic DANGLOT on 26/04/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK: -PROPERTIES
    
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet weak var topRightPlusButton: UIButton!
    @IBOutlet weak var downRightPlusButton: UIButton!
    @IBOutlet weak var shareView: UIView!
    var butonSelectedbuton : UIButton!
    var swipeGestureRecognizer : UISwipeGestureRecognizer?
    
    // MARK: - METHODE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // reconnaissance du geste
        swipeGestureRecognizer = UISwipeGestureRecognizer (target :self, action : #selector(swipeToShare))
        guard let swipeGestureRecognizer = swipeGestureRecognizer else {return}
        swipeGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.up
        
        shareView.addGestureRecognizer(swipeGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// direction du swipe selon l'orientation du telephone
    @objc private func setupSwipeDirection() {
        if UIDevice.current.orientation.isLandscape {
            swipeGestureRecognizer?.direction = UISwipeGestureRecognizer.Direction.left
        } else {
            swipeGestureRecognizer?.direction = UISwipeGestureRecognizer.Direction.up
        }
    }
    
    ///animation du swipe
    @objc private func swipeToShare() {
        // permet ld'ouvrir la page de partage
        let activityController = UIActivityViewController(activityItems: [shareView.image], applicationActivities: nil)
        
        switch swipeGestureRecognizer?.direction {
        case UISwipeGestureRecognizer.Direction.up:
            UIView.animate(withDuration: 1, animations: {
                self.shareView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
            }, completion:  nil)
        case UISwipeGestureRecognizer.Direction.left:
            UIView.animate(withDuration: 1, animations: {
                self.shareView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            }, completion: nil)
            
        default :
            break
        }
        // remise en place de la vue a sa position initialle

        activityController.completionWithItemsHandler = {_, _, _, _ in UIView.animate(withDuration: 1) {
            self.shareView.transform = .identity}}
        //sauvegarde dans la bibliotheque
        present(activityController, animated: true, completion: nil)
    }
    
    ///permet la selection et l'acces dans le bibliotheque
    @IBAction private func chooseImage(_ sender: UIButton) {
        butonSelectedbuton = sender
        let  imagePickerController = UIImagePickerController ()
        imagePickerController.delegate = self
        self .present ( imagePickerController, animated: true, completion: nil )
    }
    
    /// sauvegarde la selection choisi dans la bibiotheque de photo sur le bouton
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        let image = info[ UIImagePickerController.InfoKey.originalImage] as! UIImage
        butonSelectedbuton.setImage(image, for: .normal)
        butonSelectedbuton.imageView?.contentMode = .scaleAspectFill
        picker.dismiss ( animated: true, completion: nil )
    }
    
    
    /// selection du layout
    @IBAction private func layoutButtonTap(_ sender: UIButton) {
        for button in layoutButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        switch sender.tag {
        case 0:
            topRightPlusButton.isHidden = true
            downRightPlusButton.isHidden = false
        case 1:
            topRightPlusButton.isHidden = false
            downRightPlusButton.isHidden = true
        case 2:
            topRightPlusButton.isHidden = false
            downRightPlusButton.isHidden = false
        default:
            break
        }
    }
    
    
}

