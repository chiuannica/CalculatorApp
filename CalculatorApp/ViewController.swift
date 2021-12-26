//
//  ViewController.swift
//  CalculatorApp
//
//  Created by Annica Chiu on 12/24/21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var otherLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        otherTextField.isHidden = true
        otherLabel.isHidden = true
    }
    
    @IBAction func onOtherTextFieldChanged(_ sender: Any) {
        let tipPercentageChosen = Double(otherTextField.text!) ?? 0
        let bill = Double(billAmountTextField.text!) ?? 0
        updateFields(tipPercentageChosen: tipPercentageChosen, bill: bill)
    }
    @IBAction func onBillAmountChanged(_ sender: Any) {
        
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        let tipPercentages = [0.15, 0.18, 0.2, -1]
        
        let index = tipControl.selectedSegmentIndex
        var tipPercentageChosen = 0.0
        
        let bill = Double(billAmountTextField.text!) ?? 0
        if (index != 3) {
            tipPercentageChosen = tipPercentages[index]
            updateFields(tipPercentageChosen: tipPercentageChosen, bill: bill)
        } else {
            otherTextField.isHidden = false
            otherLabel.isHidden = false
        }
    }
    func updateFields(tipPercentageChosen: Double, bill: Double) {
        let tip = tipPercentageChosen * bill
        let total = tip + bill
        tipAmountLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
}

