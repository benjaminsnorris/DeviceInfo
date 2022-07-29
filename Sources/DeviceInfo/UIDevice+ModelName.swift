/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

#if !os(macOS)
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
        let mirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
}

// https://www.theiphonewiki.com/wiki/Models
private let DeviceList = [
    
    // MARK: - iPod
    
    /* iPod 5 */
    "iPod5,1": "iPod Touch 5",
    /* iPod 6 */
    "iPod7,1": "iPod Touch 6",
    /* iPod 7 */
    "iPod9,1": "iPod Touch 7",
    
    
    // MARK: - iPhone
    
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
    /* iPhone 8 */
    "iPhone10,1": "iPhone 8", "iPhone10,4": "iPhone 8",
    /* iPhone 8 Plus */
    "iPhone10,2": "iPhone 8 Plus", "iPhone10,5": "iPhone 8 Plus",
    /* iPhone X */
    "iPhone10,3": "iPhone X", "iPhone10,6": "iPhone X",
    /* iPhone XR */
    "iPhone11,8": "iPhone XR",
    /* iPhone XS */
    "iPhone11,2": "iPhone XS",
    /* iPhone XS Max */
    "iPhone11,6": "iPhone XS Max", "iPhone11,4": "iPhone XS Max",
    /* iPhone 11 */
    "iPhone12,1": "iPhone 11",
    /* iPhone 11 Pro */
    "iPhone12,3": "iPhone 11 Pro",
    /* iPhone 11 Pro Max */
    "iPhone12,5": "iPhone 11 Pro Max",
    /* iPhone SE (2nd generation) */
    "iPhone12,8": "iPhone SE (2nd generation)",
    /* iPhone 12 mini */
    "iPhone13,1": "iPhone 12 mini",
    /* iPhone 12 */
    "iPhone13,2": "iPhone 12",
    /* iPhone 12 Pro */
    "iPhone13,3": "iPhone 12 Pro",
    /* iPhone 12 Pro Max */
    "iPhone13,4": "iPhone 12 Pro Max",
    
    
    // MARK: - iPad
    
    /* iPad 2 */
    "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
    /* iPad 3 */
    "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
    /* iPad 4 */
    "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
    /* iPad 5th Generation */
    "iPad6,11": "iPad 5", "iPad6,12": "iPad 5",
    /* iPad 6th Generation */
    "iPad7,5": "iPad 6", "iPad7,6": "iPad 6",
    /* iPad 7th Generation */
    "iPad7,11": "iPad 7", "iPad7,12": "iPad 7",
    /* iPad 8th Generation*/
    "iPad11,6": "iPad 8", "iPad11,7": "iPad 8",
    
    
    // MARK: - iPad Air
    
    /* iPad Air */
    "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
    /* iPad Air 2 */
    "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
    /* iPad Air 3rd Generation */
    "iPad11,3": "iPad Air 3", "iPad11,4": "iPad Air 3",
    /* iPad Air 4th Generation */
    "iPad13,1": "iPad Air 4", "iPad13,2": "iPad Air 4",
    /* iPad Mini */
    "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
    /* iPad Mini 2 */
    "iPad4,4": "iPad Mini 2", "iPad4,5": "iPad Mini 2", "iPad4,6": "iPad Mini 2",
    /* iPad Mini 3 */
    "iPad4,7": "iPad Mini 3", "iPad4,8": "iPad Mini 3", "iPad4,9": "iPad Mini 3",
    /* iPad Mini 4 */
    "iPad5,1": "iPad Mini 4", "iPad5,2": "iPad Mini 4",
    /* iPad Mini 5 */
    "iPad11,1": "iPad Mini 5", "iPad11,2": "iPad Mini 5",
    
    
    // MARK: - iPad Pro
    
    /* iPad Pro (12.9 inch) */
    "iPad6,7": "iPad Pro (12.9 inch)", "iPad6,8": "iPad Pro (12.9 inch)",
    /* iPad Pro (9.7 inch) */
    "iPad6,3": "iPad Pro (9.7 inch)", "iPad6,4": "iPad Pro (9.7 inch)",
    /* iPad Pro (12.9 inch) 2nd generation */
    "iPad7,1": "iPad Pro (12.9 inch) (2nd generation)", "iPad7,2": "iPad Pro (12.9 inch) (2nd generation)",
    /* iPad Pro (10.5 inch) */
    "iPad7,3": "iPad Pro (10.5 inch)", "iPad7,4": "iPad Pro (10.5 inch)",
    /* iPad Pro (11 inch) */
    "iPad8,1": "iPad Pro (11 inch)", "iPad8,2": "iPad Pro (11 inch)", "iPad8,3": "iPad Pro (11 inch)", "iPad8,4": "iPad Pro (11 inch)",
    /* iPad Pro (12.9 inch) (3rd generation) */
    "iPad8,5": "iPad Pro (12.9 inch) (3rd generation)", "iPad8,6": "iPad Pro (12.9 inch) (3rd generation)", "iPad8,7": "iPad Pro (12.9 inch) (3rd generation)", "iPad8,8": "iPad Pro (12.9 inch) (3rd generation)",
    /* iPad Pro (11 inch) (2nd generation) */
    "iPad8,9": "iPad Pro (11 inch) (2nd generation)", "iPad8,10": "iPad Pro (11 inch) (2nd generation)",
    /* iPad Pro (12.9 inch) (4th generation) */
    "iPad8,11": "iPad Pro (12.9 inch) (4th generation)", "iPad8,12": "iPad Pro (12.9 inch) (4th generation)",
    
    // MARK: - Simulator
    
    /* Simulator */
    "x86_64": "Simulator", "i386": "Simulator"
]

#endif
