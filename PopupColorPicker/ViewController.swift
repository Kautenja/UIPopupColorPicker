//
//  ViewController.swift
//  PopupColorPicker
//
//  Created by James Kauten on 7/18/17.
//  Copyright © 2017 CK Software. All rights reserved.
//

import UIKit
import UIPopupColorPicker

/// The main entry point for the application
class ViewController: UIViewController {
    
    /// Respond to a color change event from the popup
    /// - parameters:
    ///  - color: the selected color
    func colorDidChange(color: UIColor?) {
        guard let newColor = color else {
            view.backgroundColor = UIColor.white
            return
        }
        view.backgroundColor = newColor
    }
    
    /// respond to a press on the "select a color" button
    @IBAction func selectAColor() {
        let _ = UIPopupColorPicker.show(on: self, block: colorDidChange)
    }
    
    /// respond to a press on the "select a color" button
    @IBAction func selectAColorWithCustomTintAndBG() {
        let popup = UIPopupColorPicker.show(on: self) { color in
            self.colorDidChange(color: color)
        }
        popup.tintColor = #colorLiteral(red: 0.1568514521, green: 0.680490051, blue: 0.9768045545, alpha: 1)
        popup.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        popup.buttonFont = UIFont(name: "HelveticaNeue", size: 18.0)!
        popup.colorList = [UIColor.gray, UIColor.blue, UIColor.yellow]
    }
    
}

