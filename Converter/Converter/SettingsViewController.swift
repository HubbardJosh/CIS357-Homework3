//
//  SettingsViewController.swift
//  Converter
//
//  Created by Josh Hubbard on 9/23/20.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit)
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var pick: UIPickerView!
    var fromSelected = false
    var toSelected = false
    
    var lengthUnits = ["Yards", "Meters", "Miles"]
    var volumeUnits = ["Liters", "Gallons", "Quarts"]
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if vars.currMode == "Length" {
            fromLabel.text = vars.currFromL
            toLabel.text = vars.currToL
        } else {
            fromLabel.text = vars.currFromV
            toLabel.text = vars.currToV
        }
        
        fromLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showPickerFrom)))
        toLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showPickerTo)))
        
        pick.delegate = self
        pick.dataSource = self
    }
    
    @objc func showPickerFrom() {
        pick.isHidden = false
        fromSelected = true
        toSelected = false
    }
    @objc func showPickerTo() {
        pick.isHidden = false
        toSelected = true
        fromSelected = false
    }
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if vars.currMode == "Length" {
            return lengthUnits.count
        } else {
            return volumeUnits.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if vars.currMode == "Length" {
            return lengthUnits[row]
        } else {
            return volumeUnits[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if vars.currMode == "Length" {
            if fromSelected {
                fromLabel.text = lengthUnits[row]
            } else {
                toLabel.text = lengthUnits[row]
            }
        } else {
            if fromSelected {
                fromLabel.text = volumeUnits[row]
            } else {
                toLabel.text = volumeUnits[row]
            }
        }
        
        pick.isHidden = true
        toSelected = false
        fromSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            if let _ = segue.destination as? ViewController {
                var fromSendL: LengthUnit = .Meters
                var toSendL: LengthUnit = .Meters
                var fromSendV: VolumeUnit = .Gallons
                var toSendV: VolumeUnit = .Gallons
                
                if let d = self.delegate {
                    if vars.currMode == "Length" {
                        for x in LengthUnit.allCases {
                            if x.rawValue == fromLabel.text {
                                fromSendL = x
                            }
                            if x.rawValue == toLabel.text {
                                toSendL = x
                            }
                        }
                        d.settingsChanged(fromUnits: fromSendL, toUnits: toSendL)
                    } else {
                        for x in VolumeUnit.allCases {
                            if x.rawValue == fromLabel.text {
                                fromSendV = x
                            }
                            if x.rawValue == toLabel.text {
                                toSendV = x
                            }
                        }
                        d.settingsChanged(fromUnits: fromSendV, toUnits: toSendV)
                    }
                }
            }
        }
    }
}
