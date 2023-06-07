import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var taxTextField: UITextField!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var overallTotalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherTextField.isHidden = true
        otherLabel.isHidden = true
        stackView.spacing = 10
    }
    
    @IBAction func onBillAmountChanged(_ sender: Any) {
        updateFields()
    }
    
    @IBAction func onTipAmountChanged(_ sender: Any) {
        updateFields()
    }
    
    @IBAction func onOtherTextFieldChanged(_ sender: Any) {
        updateFields()
    }
    
    @IBAction func onTaxAmountChanged(_ sender: Any) {
        updateFields()
    }
    
    func getTip() -> Double {
        let tipPercentages = [0.15, 0.18, 0.2, -1]
        let index = tipControl.selectedSegmentIndex
        var tipPercentageChosen = 0.0
        
        if index != 3 {
            tipPercentageChosen = tipPercentages[index]
        } else {
            otherTextField.isHidden = false
            otherLabel.isHidden = false

            guard let otherText = otherTextField.text, let otherPercentage = Double(otherText) else {
                return 0.0
            }
            tipPercentageChosen = otherPercentage / 100.0
        }
        return tipPercentageChosen
    }
    
    func getTax() -> Double {
        guard let taxText = taxTextField.text, let taxPercentage = Double(taxText) else {
            return 0
        }
        return taxPercentage / 100.0
    }
    
    func updateFields() {
        let taxPercentage = getTax()
        let tipPercentage = getTip()
        
        let individualAmounts = billAmountTextField.text!
            .components(separatedBy: " ")
            .compactMap { Double($0) }
        ;
        
        var amountsWithTax: [Double] = []
        var tipAmounts: [Double] = []
        var individualTotals: [Double] = []
        
        var overallTotal = 0.0
        
        for amount in individualAmounts {
            let amountWithTax =  amount + (amount * taxPercentage)
            amountsWithTax.append(amountWithTax)
            
            let tip = tipPercentage * amountWithTax
            tipAmounts.append(tip)
            
            let individualTotal = amountWithTax + tip
            individualTotals.append(amountWithTax + tip)
            
            overallTotal += individualTotal
        }
        
        
        let amountsWithTaxString = amountsWithTax
            .map { String(format: "$%.2f", $0) }
            .joined(separator: " ")
        
        let tipAmountsString = tipAmounts
            .map { String(format: "$%.2f", $0) }
            .joined(separator: " ")
        
        let totalString = individualTotals
            .map { String(format: "$%.2f", $0) }
            .joined(separator: " ")
        
        amountLabel.text = String(amountsWithTaxString)
        tipAmountLabel.text = String(tipAmountsString)
        totalLabel.text = String(totalString)
        overallTotalLabel.text = String(format: "$%.2f", overallTotal)
        
    }
}
