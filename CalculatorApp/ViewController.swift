import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var splitBillControl: UISegmentedControl!
    @IBOutlet weak var splitTipControl: UISegmentedControl!
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
        stackView.spacing = 2
        tipControl.addTarget(self, action: #selector(onTipAmountChanged(_:)), for: .valueChanged)
        
        splitBillControl.addTarget(self, action: #selector(onSplitBillChanged(_:)), for: .valueChanged)

        
        splitTipControl.addTarget(self, action: #selector(onSplitTipChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func onBillAmountChanged(_ sender: Any) {
        updateFields()
    }
    
    @IBAction func onSplitBillChanged(_ sender: Any) {
        updateFields()
    }
    
    @IBAction func onSplitTipChanged(_ sender: Any) {
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
    
    func getBillSplit() -> String {
        var billSplit = "proportional"
        let billSplitIndex = splitBillControl.selectedSegmentIndex
        if (billSplitIndex == 1) {
            billSplit = "even"
        }
        return billSplit
    }
    
    func getTipSplit() -> String {
        var tipSplit = "proportional"
        let tipSplitIndex = splitTipControl.selectedSegmentIndex
        if (tipSplitIndex == 1) {
            tipSplit = "even"
        }
        return tipSplit
    }
    
    func getIndividualAmounts() -> [Double] {
        return billAmountTextField.text!
            .components(separatedBy: " ")
            .compactMap { Double($0) }
        ;
    }
    
    func updateFields() {
        let taxMultiplier = getTax()
        let tipMultiplier = getTip()
        let billSplit = getBillSplit()
        let tipSplit = getTipSplit()
        let individualAmounts = getIndividualAmounts()
        
        var amountsWithTax: [Double] = []
        var tipAmounts: [Double] = []
        var individualTotals: [Double] = []
        var overallTotal = 0.0
        
        if (billSplit == "proportional" && tipSplit == "proportional") {
            // calculate proportionally
            // for each amount, calculate its tax and add it
            // for the combined amount and tax, calculate its tip
            // combine the amount with tax and tip to get individual total
            // combine all individual totals to get overall total
            for amount in individualAmounts {
                let amountWithTax =  amount + (amount * taxMultiplier)
                amountsWithTax.append(amountWithTax)
                
                let tip = tipMultiplier * amountWithTax
                tipAmounts.append(tip)
                
                let individualTotal = amountWithTax + tip
                individualTotals.append(amountWithTax + tip)
                
                overallTotal += individualTotal
            }
        } else if (billSplit == "even" && tipSplit == "even") {
            // divide everything evenly
            // add all amounts to get the overall amount
            // calculate the overall tax from the amount
            // calculate the overall tip from the amount with tax
            // split the overall amount with tax and overall tip evenly
            // the overall total is overall amount with tax and overall tip
            var overallAmount = 0.0
            for amount in individualAmounts {
                overallAmount += amount
            }
            let overallAmountWithTax = overallAmount + (overallAmount * taxMultiplier)
            let overallTip = (overallAmountWithTax * tipMultiplier)
            overallTotal = overallAmountWithTax + overallTip
            
            let individualAmountWithTax = (overallAmountWithTax) / Double(individualAmounts.count)
            
            let individualTip = overallTip / Double(individualAmounts.count)
            
            let individualTotal = overallTotal / Double(individualAmounts.count)

            for _ in individualAmounts {
                amountsWithTax.append(individualAmountWithTax)
                tipAmounts.append(individualTip)
                individualTotals.append(individualTotal)
            }
        } else if (billSplit == "proportional" && tipSplit == "even") {
            
            // split the bill proportionally, pay tip evenly
            // calculate the proportional amount with tax
            // calculate the total tip, split evenly
            // individual totals are the proportional
            
            var overallAmountWithTax = 0.0
            for amount in individualAmounts {
                let amountWithTax =  amount + (amount * taxMultiplier)
                overallAmountWithTax += (amount + (amount * taxMultiplier))
                amountsWithTax.append(amountWithTax)
            }
            let overallTip = (overallAmountWithTax * tipMultiplier)
            let individualTip = overallTip / Double(individualAmounts.count)
                            
            for amountWithTax in amountsWithTax {
                tipAmounts.append(individualTip)
                individualTotals.append(amountWithTax + individualTip)
            }
            overallTotal = overallAmountWithTax + overallTip
        } else if (billSplit == "even" && tipSplit == "proportional") {
            // split the amounts evenly, split the tip proportionally
            // calculate the proportional individual amount with tax to calculate the proportional tip
            // clear the amounts and split the overall amount with tax evenly
            
            var overallAmountWithTax = 0.0
            for amount in individualAmounts {
                let amountWithTax = amount + (amount * taxMultiplier)
                amountsWithTax.append(amountWithTax)
                overallAmountWithTax += amountWithTax
            }
            var overallTip = 0.0
            for amount in amountsWithTax {
                let individualTip = amount * tipMultiplier
                tipAmounts.append(individualTip)
                overallTip += individualTip
            }
            let individualAmountWithTax = overallAmountWithTax / Double(individualAmounts.count)
            
            amountsWithTax.removeAll()
            for tip in tipAmounts {
                individualTotals.append(individualAmountWithTax + tip)
                amountsWithTax.append(individualAmountWithTax)
            }
            overallTotal = overallAmountWithTax + overallTip
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
