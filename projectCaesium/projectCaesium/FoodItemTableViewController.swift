//
//  FoodItemTableViewController.swift
//  123
//
//  Created by Stephen Alger on 23/04/2018.
//  Copyright © 2018 Stephen Alger. All rights reserved.
//

import UIKit

class FoodItemTableViewController: UITableViewController {

    //MARK: Properties
    
    //create array of objects of class type: foodItem
    var foodItems = [FoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load our sample data
        loadSampleFoods()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //alert the table view controller to only display one section.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return a single row for every food object in the 'foodItems' array.
        return foodItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FoodItemTableViewCell"
        
        //We perform a downcasting on the returned object from the UITableViewCell class to our FoodItemTableViewCell by using 'as?'. We then use the 'guard let' expression to safely unwrap the optional just returned.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FoodItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FoodItemTableViewCell.")
        }
        
        //Get the corresponding foodItem for the data source layout.
        let foodItem = foodItems[indexPath.row]
        

        cell.nameLabel.text = foodItem.foodName
        cell.cellImage.image = foodItem.foodPhoto
        cell.kcalLabel.text =   String(foodItem.foodCalories)
        cell.carbLabel.text = String(foodItem.foodCarbs)
        cell.proteinLabel.text = String(foodItem.foodProteins)
        cell.fatLabel.text = String(foodItem.foodFats)
        
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadSampleFoods() {
        
        //load in 3 food images
        let photo1 = UIImage(named: "Sample1")
        let photo2 = UIImage(named: "Sample2")
        let photo3 = UIImage(named: "Sample3")
        let photo4 = UIImage(named: "Sample4")
        let photo5 = UIImage(named: "Sample5")
        
        guard let foodOne = FoodItem(Time: "20.30", Gram: 100, Name: "Crisps & Dip", Photo: photo1, Carbs: 30, Fats: 15, Proteins: 5, Kcals: 200) else {
            fatalError("Unable to instantiate foodOne")
        }
        
        
        guard let foodTwo = FoodItem(Time: "21.30", Gram: 300, Name: "Burger", Photo: photo1, Carbs: 5, Fats: 29, Proteins: 24, Kcals: 377) else {
            fatalError("Unable to instantiate foodOne")
        }
        
        guard let foodThree = FoodItem(Time: "22.30", Gram: 50, Name: "Caesar Salad", Photo: photo1, Carbs: 30, Fats: 5, Proteins: 10, Kcals: 205) else {
            fatalError("Unable to instantiate foodOne")
        }
        
        guard let foodFour = FoodItem(Time: "23.30", Gram: 500, Name: "Pepper Steak", Photo: photo1, Carbs: 5, Fats: 29, Proteins: 24, Kcals: 377) else {
            fatalError("Unable to instantiate foodOne")
        }
        
        guard let foodFive = FoodItem(Time: "23.32", Gram: 50, Name: "Mixed Fruit Dessert", Photo: photo1, Carbs: 30, Fats: 0, Proteins: 3, Kcals: 132) else {
            fatalError("Unable to instantiate foodOne")
        }
        
        foodItems += [foodOne, foodTwo, foodThree, foodFour, foodFive]
        
    }

}