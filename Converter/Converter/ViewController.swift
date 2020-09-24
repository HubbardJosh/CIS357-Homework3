//
//  ViewController.swift
//  Converter
//
//  Created by Josh Hubbard on 9/23/20.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, SettingsViewControllerDelegate {
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit) {
        fromLabel.text = fromUnits.rawValue
        toLabel.text = toUnits.rawValue
        fromTextfield.placeholder = "Enter length in \(fromUnits.rawValue)"
        toTextfield.placeholder = "Enter length in \(toUnits.rawValue)"
        vars.currFromL = fromUnits.rawValue
        vars.currToL = toUnits.rawValue
    }
    
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit) {
        fromLabel.text = fromUnits.rawValue
        toLabel.text = toUnits.rawValue
        fromTextfield.placeholder = "Enter volume in \(fromUnits.rawValue)"
        toTextfield.placeholder = "Enter volume in \(toUnits.rawValue)"
        vars.currFromV = fromUnits.rawValue
        vars.currToV = toUnits.rawValue
    }
    

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var fromTextfield: DecimalMinusTextField!
    @IBOutlet weak var toTextfield: DecimalMinusTextField!
    
    var fromVal: Double = 0.0
    var toVal: Double = 0.0
    
    var currMode = CalculatorMode.Length
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromTextfield.delegate = self
        toTextfield.delegate = self
    }
    
    @IBAction func modePressed(_ sender: UIButton) {
        fromTextfield.text?.removeAll()
        toTextfield.text?.removeAll()
        dismissKeyboard()
        
        if vars.currMode == "Length" {
            currMode = CalculatorMode.Volume
            vars.currMode = "Volume"
            fromLabel.text = vars.currFromV
            toLabel.text = vars.currToV
            fromTextfield.placeholder = "Enter volume in \(vars.currFromV)"
            toTextfield.placeholder = "Enter volume in \(vars.currToV)"
        } else {
            currMode = CalculatorMode.Length
            vars.currMode = "Length"
            fromLabel.text = vars.currFromL
            toLabel.text = vars.currToL
            fromTextfield.placeholder = "Enter length in \(vars.currFromL)"
            toTextfield.placeholder = "Enter length in \(vars.currToL)"
        }
    }
    @IBAction func clearPressed(_ sender: UIButton) {
        fromTextfield.text?.removeAll()
        toTextfield.text?.removeAll()
        dismissKeyboard()
    }
    @IBAction func calculatePressed(_ sender: UIButton) {
        dismissKeyboard()
        if fromTextfield.hasText {
            fromVal = Double(fromTextfield.text!)!
            if vars.currMode == "Length" {
                toTextfield.text = "\(convert(from: vars.currFromL, to: vars.currToL))"
            } else {
                toTextfield.text = "\(convert(from: vars.currFromV, to: vars.currToV))"
            }
            
        } else if toTextfield.hasText {
            fromVal = Double(toTextfield.text!)!
            if vars.currMode == "Length" {
                fromTextfield.text = "\(convert(from: vars.currToL, to: vars.currFromL))"
            } else {
                fromTextfield.text = "\(convert(from: vars.currToV, to: vars.currFromV))"
            }
        }
        
        
    }
    
    @IBAction func fromFocused(_ sender: Any) {
        if toTextfield.hasText {
            toTextfield.text?.removeAll()
        }
    }
    @IBAction func toFocused(_ sender: Any) {
        if fromTextfield.hasText {
            fromTextfield.text?.removeAll()
        }
    }
    
    func convert(from: String, to: String) -> Double {
        
        var calculated: Double = fromVal
        switch from {
        case "Meters":
            if to == "Yards" {
                calculated *= 1.09361
            } else if to == "Miles" {
                calculated *= 0.000621371
            }
        case "Yards":
            if to == "Meters" {
                calculated *= 0.9144
            } else if to == "Miles" {
                calculated *= 0.000568182
            }
        case "Miles":
            if to == "Yards" {
                calculated *= 1760.0
            } else if to == "Meters" {
                calculated *= 1609.34
            }
            
        case "Liters":
            if to == "Gallons" {
                calculated *= 0.264172
            } else if to == "Quarts" {
                calculated *= 1.05669
            }
        case "Gallons":
            if to == "Liters" {
                calculated *= 3.78541
            } else if to == "Quarts" {
                calculated *= 4.0
            }
        case "Quarts":
            if to == "Gallons" {
                calculated *= 0.25
            } else if to == "Liters" {
                calculated *= 0.946353
            }
        default:
            break
        }
        
        return calculated
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            if let dest = segue.destination as? SettingsViewController {
                
                if vars.currMode == "Length" {
                    vars.currFromL = fromLabel.text!
                    vars.currToL = toLabel.text!
                } else {
                    vars.currFromV = fromLabel.text!
                    vars.currToV = toLabel.text!
                }
                
                dest.delegate = self
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fromTextfield.text?.removeAll()
        toTextfield.text?.removeAll()
        if vars.currMode == "Length" {
            fromLabel.text = vars.currFromL
            toLabel.text = vars.currToL
            fromTextfield.placeholder = "Enter length in \(vars.currFromL)"
            toTextfield.placeholder = "Enter length in \(vars.currToL)"
        } else {
            fromLabel.text = vars.currFromV
            toLabel.text = vars.currToV
            fromTextfield.placeholder = "Enter volume in \(vars.currFromV)"
            toTextfield.placeholder = "Enter volume in \(vars.currToV)"
        }
        
    }

}

