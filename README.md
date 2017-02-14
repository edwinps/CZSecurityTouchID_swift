CZSecurityTouchID_swift
=============

CZSecurityTouchID_swift secures your app by requiring a Touch ID fingerprint or passcode.

Validation                |  Adjustment
:-----------------------:|:-------------------------:
![](doc/validation.gif)  |   ![](doc/settings.gif)

Installation
------------
The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Just add the following line to your Podfile:

```ruby
pod 'CZSecurityTouchID_swift'
```

Usage
-----

### 1. import the class
```swift
import CZSecurityTouchID_swift
```

### Create a simple validation view

In order to conform to the PinViewControllerValidate protocol you have to adopt it in your UIViewController
```swift
class ViewController: UIViewController,PinViewControllerValidateDelegate
```

To conform to the PinViewControllerValidateDelegate you have to implement the following functions:
```swift
func pinViewControllerDidSetWrongPin(action :pinViewAction){
        
}
    
func pinViewControllerDidSetСorrectPin(action: pinViewAction){

}
```

To create a validation view
```swift
let viewController = = FingerPrint.sharedInstance.createPinViewWithScope(scope: .PinViewControllerScopeValidate, validationDelegate: self)
```
* `Scope`: 
	* PinViewControllerScopeValidate : the view for request the pin or finger print (Need to have some pin saved)
	* PinViewControllerScopeCreate : the view for create a new pincode
	* PinViewControllerScopeChange : the view for change the pincode
	* PinViewControllerScopeDesactive : the view to delete the pincode

* `validationDelegate`:  PinViewControllerValidateDelegate
This method return to UIViewController and you can add in your navigation flow

### Create an adjustment view that covers all scope
Is a simple view to configure all the options of the pin and touch id

To create a setting view
```swift
let viewController = FingerPrint.sharedInstance.createSettingViewWithAppearance(settingAppearance: nil, pinAppearance: nil)
```
This method return to UIViewController and you can add in your navigation flow

### Other Setting 

**Setting up length For Pin code**
By default is 4
```swift
FingerPrint.sharedInstance.lengthCodePin = 4
```

**Setting up the validation view appearance**
```swift
let appearance = PinAppearance.defaultAppearance()
appearance.logo = UIImage(named:"sc_logo")
/*You can configure all the attributes you need */
FingerPrint.sharedInstance.appearance = appearance;
```

**Setting up the adjustment view appearance and PinCode View**
```swift
let settingAppearance = SettingsAppearance.defaultAppearance()
settingAppearance.titleGroupText = "Group title"
/*You can configure all the attributes you need */

let appearance = PinAppearance.defaultAppearance()
appearance.logo = UIImage(named:"sc_logo")
/*You can configure all the attributes you need */
let viewController = FingerPrint.sharedInstance.createSettingViewWithAppearance(settingAppearance: settingAppearance, pinAppearance: appearance)
```
