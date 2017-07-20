# UIPopupColorPicker

## Screenshots

The standard theme

![standard][]

An example of custom theme utilizing tint color, background color, and fonts

![themed][]

[standard]: https://user-images.githubusercontent.com/2184469/28428261-78c0d20a-6d3e-11e7-8bbb-538066ae9696.PNG
[themed]: https://user-images.githubusercontent.com/2184469/28428266-7b990cae-6d3e-11e7-98b2-dddc01dc55d1.PNG

## Installation

### Carthage

add the folowing to your Carfile:

```
github "kautenja/UIPopupColorPicker" "master"
```

## Example

To run the example project, clone the repo, and it in Xcode on devices of your choosing, there is an example UI
setup to access the picker.

### Code

UIPopupColorPicker is accessed through the single static function:

```swift
let _ = UIPopupColorPicker.show(on: self, block: nil)
```

This function returns an instance of BColorPicker in case you might want to
manipulate some of the controller manually.

```swift
let popup = UIPopupColorPicker.show(on: self, handledBy: nil)
popup.tintColor = #colorLiteral(red: 0.1568514521, 
                                green: 0.680490051, 
                                blue: 0.9768045545, 
                                alpha: 1)
popup.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
popup.buttonFont = UIFont(name: "HelveticaNeue", size: 18.0)!
popup.colorList = [UIColor.gray, UIColor.blue, UIColor.yellow]
```

The reccomended way of handling color change is to implement a handler function
in the host view controller like this:

```swift
/// Handle a color selection from BColorPicker
func colorDidChange(to color: UIColor?) {
    
}

let _ = UIPopupColorPicker.show(on: self, block: colorDidChange)
```

or like this using an escaping closure

```swift
let _ = UIPopupColorPicker.show(on: self) { color in
// handle color change with escaping closure
}
```

see [ViewController](PopupColorPicker/ViewController.swift) for a production 
example of how this might come together


## License

UIPopupColorPicker is available under the MIT license. See the [LICENSE](./LICENSE) file for more 
info.
