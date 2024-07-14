//
//  ResourceHelper.swift
//  iOSOnePaitWidget
//
//  Created by Phu on 14/7/24.
//

public class ResourcesHelper {
    static func getResourcesBundle() -> Bundle? {
        let bundleURL = Bundle(for: self).url(forResource: "iOSOnePaitWidget", withExtension: "bundle")
        guard let url = bundleURL else {
            return nil
        }
        return Bundle(url: url)
    }
    static func loadImageFromResourceBundle(imageName: String) -> UIImage? {
        guard let bundle = getResourcesBundle() else {
            return nil
        }
        let imageFileName = "\(imageName)"
        return UIImage(named: imageFileName, in: bundle, compatibleWith: nil)
    }
}

