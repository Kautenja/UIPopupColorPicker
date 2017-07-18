//
//  BColorPicker.swift
//  BColorPicker
//
//  Created by James Kauten on 12/25/16.
//  Copyright © 2016 James Kauten. All rights reserved.
//

import PopupDialog

/// A class to present popups for selecting a color
public class BColorPicker: UIViewController {
    
    /// the popup that this picker is contained in
    var popup: PopupDialog!
    
    /// the array of UI colors to select from
    var colors: [UIColor] = FlatColors.all
    
    /// the list of colors to display
    public var colorList: [UIColor] {
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
    public var tintColor: UIColor {
        get {
            return clearButton.tintColor
        }
        set {
            clearButton.tintColor = newValue
            cancelButton.tintColor = newValue
        }
    }
    
    /// the font for the buttons
    public var buttonFont: UIFont? {
        get {
            return clearButton.titleLabel?.font
        }
        set {
            clearButton.titleLabel?.font = newValue
            cancelButton.titleLabel?.font = newValue
        }
    }
    
    /// the header view that contains the buttons
    @IBOutlet var header: UIView!
    
    /// the table view that contains the color cells
    @IBOutlet var tableView: UITableView!
    
    /// the background color for the table and header
    public var backgroundColor: UIColor? {
        get {
            return header.backgroundColor
        }
        set {
            header.backgroundColor = newValue
            tableView.backgroundColor = newValue
        }
    }
    
    
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
                         handledBy handler: @escaping ((UIColor?)->Void)) -> BColorPicker {
        let frameworkBundle = Bundle(for: BColorPicker.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("BColorPicker.bundle")

        let resourceBundle = Bundle(url: bundleURL!)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "BColorPicker", bundle:resourceBundle )
        let bColorPicker = storyboard.instantiateViewController(withIdentifier: "BColorPicker") as! BColorPicker
        
        let popup = PopupDialog(viewController: bColorPicker, gestureDismissal: false)
        bColorPicker.popup = popup
        
        viewController.present(popup, animated: true, completion: nil)
        
        bColorPicker.handler = handler
        
        return bColorPicker
    }
    
}

extension BColorPicker: UITableViewDataSource {
    
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
        let cell = ColorCell()
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
}

extension BColorPicker: UITableViewDelegate {

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
