/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

extension UIDevice {
    
    /// User-facing device name, e.g. "iPhone 6S Plus"
    var modelName: String {
        let identifier = modelIdentifier
        return DeviceList[identifier] ?? identifier
    }
    
    /// Raw identifier of device, e.g. "iPhone8,2"
    var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)  // Swift 2.0
        var identifier = ""
        
        for child in mirror.children where child.value as? Int8 != 0 {
            identifier.append(UnicodeScalarType(UInt8(child.value as! Int8)))
        }

        return identifier
    }
    
}

// https://www.theiphonewiki.com/wiki/Models
private let DeviceList = [
    /* iPod 5 */
    "iPod5,1": "iPod Touch 5",
    /* iPod 6 */
    "iPod7,1": "iPod Touch 6",
    /* iPhone 4 */
    "iPhone3,1":  "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
    /* iPhone 4S */
    "iPhone4,1": "iPhone 4S",
    /* iPhone 5 */
    "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
    /* iPhone 5C */
    "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
    /* iPhone 5S */
    "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
    /* iPhone 6 */
    "iPhone7,2": "iPhone 6",
    /* iPhone 6 Plus */
    "iPhone7,1": "iPhone 6 Plus",
    /* iPhone 6S */
    "iPhone8,1": "iPhone 6S",
    /* iPhone 6S Plus */
    "iPhone8,2": "iPhone 6S Plus",
    /* iPhone SE */
    "iPhone8,4": "iPhone SE",
    /* iPhone 7 */
    "iPhone9,1": "iPhone 7", "iPhone9,3": "iPhone 7",
    /* iPhone 7 Plus */
    "iPhone9,2": "iPhone 7 Plus", "iPhone9,4": "iPhone 7 Plus",
    /* iPad 2 */
    "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
    /* iPad 3 */
    "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
    /* iPad 4 */
    "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
    /* iPad Air */
    "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
    /* iPad Air 2 */
    "iPad5,1": "iPad Air 2", "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
    /* iPad Mini */
    "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
    /* iPad Mini 2 */
    "iPad4,4": "iPad Mini", "iPad4,5": "iPad Mini", "iPad4,6": "iPad Mini 2",
    /* iPad Mini 3 */
    "iPad4,7": "iPad Mini", "iPad4,8": "iPad Mini", "iPad4,9": "iPad Mini 3",
    /* iPad Mini 4 */
    "iPad5,1": "iPad Mini", "iPad5,2": "iPad Mini",
    /* iPad Pro (12.9 inch) */
    "iPad6,7": "iPad Pro (12.9 inch)", "iPad6,8": "iPad Pro (12.9 inch)",
    /* iPad Pro (9.7 inch) */
    "iPad6,3": "iPad Pro (9.7 inch)", "iPad6,4": "iPad Pro (9.7 inch)",
    /* Simulator */
    "x86_64": "Simulator", "i386": "Simulator"
]
