//  DashViewController.swift
//
//  Created by Stephen Alger.
//  Copyright © 2018 Stephen Alger. All rights reserved.
//  Custom View Controller which presents a dashboard view to the user - importing the charts library

import UIKit
import Charts

class DashViewController: UIViewController {

    var macActualCalPer: Int = 1
    var pGrams: Int = 1
    var cGrams: Int = 1
    var fGrams: Int = 1
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var consumedMSG: UILabel!
    
    @IBOutlet weak var proteinGrams: UILabel!
    @IBOutlet weak var carbGrams: UILabel!
    @IBOutlet weak var fatGrams: UILabel!
    
    
    @IBOutlet weak var proCalPerc: UILabel!
    @IBOutlet weak var carbCalPerc: UILabel!
    @IBOutlet weak var fatCalPerc: UILabel!
    
    
    @IBOutlet weak var supportMSG: UITextView!
    
    var carbDataEntry = PieChartDataEntry(value: 0)
    var fatDataEntry = PieChartDataEntry(value: 0)
    var proteinDataEntry = PieChartDataEntry(value: 0)

    var macroRatioDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupNavBar()
        
        pieChart.chartDescription?.text = ""
        carbDataEntry.label = "% Carbs"
        fatDataEntry.label = "% Fats"
        proteinDataEntry.label = "% Protein"
        
        pieChart.drawEntryLabelsEnabled = true
        pieChart.drawHoleEnabled = true
        pieChart.usePercentValuesEnabled = true
        pieChart.layer.cornerRadius = 20
        pieChart.layer.backgroundColor = UIColor(named: "backG")?.cgColor

        
        supportMSG.allowsEditingTextAttributes = false
        supportMSG.isEditable = false
        
    }
    
    //occurs everytime user goes to this view
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //access, decode and count macros in foodItems array every time view is selected - keeping up to date data shown
        countMacros()
        consumedMSG.text = "Today You Have Consumed - \(String(format: "%.0f", Count.kcalCounter))kcals!"
        proteinGrams.text = "P: \(String(format: "%.0f", Count.proteinCounter))g"
        carbGrams.text = "C: \(String(format: "%.0f", Count.carbCounter))g"
        fatGrams.text = "F: \(String(format: "%.0f", Count.fatCounter))g"
        
        pGrams = Int(Count.proteinCounter)
        cGrams = Int(Count.carbCounter)
        fGrams = Int(Count.fatCounter)
        
        let pActGrams: Int = pGrams*4
        let cActGrams: Int = cGrams*4
        let fActGrams: Int = fGrams*9
        
        
        macActualCalPer = ((pActGrams+cActGrams+fActGrams) > 0) ? Int(pActGrams+cActGrams+fActGrams) : 1
        
        let pActPer =  Int((pActGrams*100) / macActualCalPer)
        let cActPer =  Int((cActGrams*100) / macActualCalPer)
        let fActPer =  Int((fActGrams*100) / macActualCalPer)
        
        proCalPerc.text = "\(String(pActPer))%cal"
        carbCalPerc.text = "\(String(cActPer))%cal"
        fatCalPerc.text = "\(String(fActPer))%cal"
        
        carbDataEntry.value = Double(Count.carbCounter)
        fatDataEntry.value = Double(Count.fatCounter)
        proteinDataEntry.value = Double(Count.proteinCounter)
        
        macroRatioDataEntries = [fatDataEntry, carbDataEntry, proteinDataEntry]
        
        updateChartData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //adopt ios11 nav bar effect
    func setupNavBar()
    {
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(values: macroRatioDataEntries, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named:"Fat"), UIColor(named:"Carb"), UIColor(named:"Protein")]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
        
        
    }
    
    //Method returns either nil or an array of FoodItem objects
    private func loadEntries() -> [FoodItem]?
    {
        //return object from memory location and downcast to an array of FoodItem objects
        return NSKeyedUnarchiver.unarchiveObject(withFile: FoodItem.ArchiveURL.path) as? [FoodItem]
    }
    
    //function which counts only today's data
    func countMacros()
    {
        //reset to Zero
        
        let todayDate = Date()

        
        Count.kcalCounter = 0
        Count.carbCounter = 0
        Count.fatCounter = 0
        Count.proteinCounter = 0
        
        //load in our array data from memory
        let foodItems = loadEntries()
        
        //traverse the array & do the counting!
        for foodItem in foodItems!
        {
            if (Calendar.current.isDate(todayDate, inSameDayAs:foodItem.LogTime))
            {
                let relativeSize = (foodItem.gramSize/100.00)
                
                Count.kcalCounter += foodItem.actCalories
                print("Here [\(Count.kcalCounter)]")
                Count.carbCounter += foodItem.foodCarbs*relativeSize
                Count.fatCounter += foodItem.foodFats*relativeSize
                Count.proteinCounter += foodItem.foodProteins*relativeSize
                
                
            }
            
            //console output
            print("not right day!")
        }
        
        //console output
        print("Here [\(Count.carbCounter)]")
        print("Here [\(Count.proteinCounter)]")
        print("Here [\(Count.fatCounter)]")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
