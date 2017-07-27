//
//  UIPopupColorPicker.swift
//  UIPopupColorPicker
//
//  Created by James Kauten on 12/25/16.
//  Copyright © 2016 James Kauten. All rights reserved.
//

import UIKit
import PopupDialog

/// a collection of flat colors for the default picker
struct FlatColors {
    static let red =        UIColor(red: 0.890, green: 0.231, blue: 0.231, alpha: 1.00)
    static let violet =     UIColor(red: 0.839, green: 0.129, blue: 0.380, alpha: 1.00)
    static let purple =     UIColor(red: 0.553, green: 0.173, blue: 0.659, alpha: 1.00)
    static let indigo =     UIColor(red: 0.369, green: 0.227, blue: 0.682, alpha: 1.00)
    static let navy =       UIColor(red: 0.227, green: 0.298, blue: 0.659, alpha: 1.00)
    static let blue =       UIColor(red: 0.157, green: 0.541, blue: 0.886, alpha: 1.00)
    static let lightBlue =  UIColor(red: 0.106, green: 0.612, blue: 0.886, alpha: 1.00)
    static let blueGreen =  UIColor(red: 0.075, green: 0.533, blue: 0.482, alpha: 1.00)
    static let green =      UIColor(red: 0.275, green: 0.616, blue: 0.290, alpha: 1.00)
    static let lime =       UIColor(red: 0.490, green: 0.698, blue: 0.286, alpha: 1.00)
    static let gold =       UIColor(red: 0.753, green: 0.784, blue: 0.259, alpha: 1.00)
    static let yellow =     UIColor(red: 0.988, green: 0.843, blue: 0.282, alpha: 1.00)
    static let ochra =      UIColor(red: 0.992, green: 0.698, blue: 0.169, alpha: 1.00)
    static let orange =     UIColor(red: 0.976, green: 0.545, blue: 0.141, alpha: 1.00)
    static let burntOrange = UIColor(red: 0.945, green: 0.322, blue: 0.173, alpha: 1.00)
    
    /// all the colors as an array
    static let all = [red,
                      violet,
                      purple,
                      indigo,
                      navy,
                      blue,
                      lightBlue,
                      blueGreen,
                      green,
                      lime,
                      gold,
                      yellow,
                      ochra,
                      orange,
                      burntOrange]
    
}

/// A class to present popups for selecting a color
open class UIPopupColorPicker: UIViewController {
    
    /// the popup that this picker is contained in
    var popup: PopupDialog!
    
    /// the array of UI colors to select from
    var colors: [UIColor] = FlatColors.all
    
    /// the list of colors to display
    open var colorList: [UIColor] {
        get {
            return colors
        }
        set {
            colors = newValue
            tableView.reloadData()
        }
    }
    
    /// the function called when a selection is made
    var handler: ((UIColor?)->Void)?
    
    /// the clear button to select no color
    @IBOutlet var clearButton: UIButton!
    
    /// the cancel button to cancel selection
    @IBOutlet var cancelButton: UIButton!
    
    /// the tint color for the buttons
    open var tintColor: UIColor {
        get {
            return clearButton.tintColor
        }
        set {
            clearButton.tintColor = newValue
            cancelButton.tintColor = newValue
        }
    }
    
    /// the font for the buttons
    open var buttonFont: UIFont? {
        get {
            return clearButton.titleLabel?.font
        }
        set {
            clearButton.titleLabel?.font = newValue
            cancelButton.titleLabel?.font = newValue
        }
    }

    /// the table view that contains the color cells
    @IBOutlet var tableView: UITableView!

    
    
    // MARK: Action functions
    
    /// Cancel the selection and dismiss the popup
    @IBAction func cancel() {
        popup.dismiss(animated: true, completion: nil)
    }
    
    /// Pass nil as the selected color and dismiss the popup
    @IBAction func clear() {
        // if there is a handler, pass the selection to it
        if let completion = handler {
            completion(nil)
        }
        popup.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Presentation
    
    /// Show the popup on top of an existing view controller with a handler
    /// - parameters:
    ///   - on: the view controller to present on top of
    ///   - handledBy: the function to handle the color selection
    open class func show(on viewController: UIViewController,
                         block handler: @escaping ((UIColor?)->Void)) -> UIPopupColorPicker {
        // load the picker from storyboard
        let name = String(describing: classForCoder())
        let bundle = Bundle(for: UIPopupColorPicker.self)
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: bundle)
        let vc = storyboard.instantiateInitialViewController()
        let picker = vc as! UIPopupColorPicker
        // create the popup
        let popup = PopupDialog(viewController: picker, gestureDismissal: false)
        picker.popup = popup
        picker.handler = handler
        // preset the popup
        viewController.present(popup, animated: true, completion: nil)
        // return it for further setup
        return picker
    }
    
}

extension UIPopupColorPicker: UITableViewDataSource {
    
    /// Return the number of cells in the table, i.e. number of colors to
    /// choose from
    /// - returns: the number of cells in the table
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    /// Decorate and return the cell for a given index
    /// - returns: the decorated cell for an index path
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
}

extension UIPopupColorPicker: UITableViewDelegate {

    /// Handle a selection to a cell
    /// - note: deselect row fixes a bug where two taps were needed to 
    ///         accomplish a selection. Suspect that popup's gesture controller 
    ///         is the cause of this
    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
        // if theres a handler, pass to it
        if let completion = handler {
            let color = colors[indexPath.item]
            completion(color)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        popup.dismiss(animated: true, completion: nil)
    }
    
}
