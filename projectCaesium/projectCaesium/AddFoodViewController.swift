//AddFoodViewController.swift
//  projectCaesium
//
//  Created by Stephen Alger.
//  Copyright © 2018 Stephen Alger. All rights reserved.
//

import UIKit
import os.log

class AddFoodViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate  {

    //MARK: Properties
    
    @IBOutlet weak var addPhotoImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var mealNameBox: UITextField!
    @IBOutlet weak var caloriesBox: UITextField!
    @IBOutlet weak var portionBox: UITextField!
    @IBOutlet weak var proteinBox: UITextField!
    @IBOutlet weak var carbBox: UITextField!
    @IBOutlet weak var fatBox: UITextField!
    
    //Create our intermediary object variable to allow us to take user input and later save or discard it
    var newFoodItem: FoodItem?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //        setupNavBar()
        
        //take in user input using delegates
        self.mealNameBox.delegate = self
        self.caloriesBox.delegate = self
        self.portionBox.delegate = self
        self.proteinBox.delegate = self
        self.carbBox.delegate = self
        self.fatBox.delegate = self
        
        //If we are editing, then fill the textboxes with the existing object properties
        if let foodItem = newFoodItem
        {
            navigationItem.title = foodItem.foodName
            mealNameBox.text   = foodItem.foodName
            addPhotoImage.image = foodItem.foodPhoto
            caloriesBox.text = String(foodItem.foodCalories)
            portionBox.text = String(foodItem.gramSize)
            proteinBox.text = String(foodItem.foodProteins)
            carbBox.text = String(foodItem.foodCarbs)
            fatBox.text = String(foodItem.foodFats)
        }
        
        
        //Disable Saves until valid entry
        disableSaveOptNoText()
    }
    
 

    @IBAction func cancelButton(_ sender: UIBarButtonItem)
    {
        //Constant boolean which establishes is the directing view controller of type UINavigationController - if true we are dealing with an Add Food Item cancel request
        let isPresentingInAddFoodMode = presentingViewController is UINavigationController

        print("vC: \(String(describing: presentingViewController))")

        //now we simply dismiss the scene and exit back to the calling view
        if isPresentingInAddFoodMode
        {
            //dismiss scene
            dismiss(animated: true, completion: nil)
        }

        //otherwsie we are dealing with a edit cancel rquest - this works
        else if let grabRefToNavigationController = navigationController
        {
            //pop scene off navigation stack and revert to
            grabRefToNavigationController.popViewController(animated: true)
        }

        //for code completeness - will not be reached...hopefully!
        else
        {

            fatalError("No Navigation controllers were presented :( ")
        }
    }
    
    
    //adopt ios11 nav bar effect
    func setupNavBar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //Gesture Recognising - User Selects to Add Image
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer)
    {
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
    
        imagePickerController.sourceType = .photoLibrary
        
        //alert View Controller when user picks image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: imagePickerControllers
    //Dismiss the Image Picker View on Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    //Deal with users selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        else
        {
            fatalError("Error Recieving Image")
        }
        
        //Display the selected image in the add food item view
        addPhotoImage.image = selectedImage
        
        // Dismiss the image selection view
        dismiss(animated: true, completion: nil)
    }
    

    //when user touches outside of editing window, dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    //MARK: UITextFieldDelegate
    //Using a delegate to handle textfield interaction
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        mealNameBox.resignFirstResponder()
        caloriesBox.resignFirstResponder()
        carbBox.resignFirstResponder()
        fatBox.resignFirstResponder()
        proteinBox.resignFirstResponder()
        portionBox.resignFirstResponder()
        
        return true
    }
    
    //prevent saves while editing...
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        disableSaveOptNoText()
        navigationItem.title = mealNameBox.text
    }
    
    // Pass the fooditem object between views should the user choose to save this entry.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        super.prepare(for: segue, sender: sender)
        
        //Check the sending object is of type UIBarButtonItem (i.e. a button) and the sending object is the same object as our save button
        guard let button = sender as? UIBarButtonItem, button === saveButton
        else
        {
            //perform console output if the intial guard statement is not true & the save button was not selected
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let Time: Date = Date()
        
        //let formatter = DateFormatter()
        //formatter.setLocalizedDateFormatFromTemplate("dd/MM/yy, HH:mm:ss")
        //let Time = formatter.string(from: Date())
        //print("This date: [\(formatter.string(from: Date()))]" )
        //var numberFormatter = NumberFormatter()
        //numberFormatter.maximumFractionDigits = 2
        //numberFormatter.string(from: Float(portionBox.text!))
        //NSNumber(value:myInteger)
        //constrain input
        //let conGram = numberFormatter.string(from: NSNumber(value: Float(portionBox.text!)!))
        //let numberFormatter2 = NumberFormatter()
        //numberFormatter2.numberStyle = NumberFormatter.Style.DecimalStyle
        //let number = numberFormatter.number(from: conGram!)
        
        
        //Memory Assignments - take user input as constants
        //(??) unrwaps the optional string returned - if nil is returned an empty string ("") is returned.
        //let Time: Date = Date() //replace with action time
        
        let Gram: Float? = Float(portionBox.text!)
        let Name = mealNameBox.text ?? ""
        let Photo = addPhotoImage.image
        let Carbs: Float? = Float(carbBox.text!)
        let Fats: Float? = Float(fatBox.text!)
        let Proteins: Float? = Float(proteinBox.text!)
        let Kcals: Int? = Int(caloriesBox.text!)
        
        
        
        
        
        
        //Configure the new FoodItem object to be passed to FoodItemTableViewController by calling FoodItem's initialiser
        
        newFoodItem = FoodItem(Time:Time, Gram: Gram!, Name: Name, Photo: Photo, Carbs: Carbs!, Fats: Fats!, Proteins: Proteins!, Kcals: Kcals!)
        
        //output new object data to console
        dump(newFoodItem)
    }
    
    //MARK: Private Functions
    private func disableSaveOptNoText()
    {
        // Disable the Save button if the text field is empty.
        let mealName = mealNameBox.text ?? ""
        let portion = portionBox.text ?? ""
        let carb = carbBox.text ?? ""
        let fat = fatBox.text ?? ""
        let protein = proteinBox.text ?? ""
        let kcals = caloriesBox.text ?? ""
        
        //simple boolean logic returning true if the each input receiving varaible is not true
        saveButton.isEnabled = !mealName.isEmpty && !portion.isEmpty && !carb.isEmpty && !fat.isEmpty && !protein.isEmpty && !kcals.isEmpty
    }

    
}

