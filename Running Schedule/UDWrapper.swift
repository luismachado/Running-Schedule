//
//  UDWrapper.swift
//  RunPortugal
//
//  Created by Luís Machado on 26/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import Foundation

struct configKeys {
    static let notificationsKey = "notifications"
    static let highResKey = "highRes"
}

struct configDefaults {
    static let notifications = false
    static let highRes = true
}

class UDWrapper {
    
    public func getObject(key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    public func getInt(key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    public func getBool(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public func getFloat(key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
    
    public func getString(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    public func getData(key: String) -> NSData? {
        return UserDefaults.standard.data(forKey: key) as NSData?
    }
    
    public func getArray(key: String) -> NSArray? {
        return UserDefaults.standard.array(forKey: key) as NSArray?
    }
    
    public func getDictionary(key: String) -> NSDictionary? {
        return UserDefaults.standard.dictionary(forKey: key) as NSDictionary?
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Get value with default value
    //-------------------------------------------------------------------------------------------
    
    public func getObject(key: String, defaultValue: AnyObject) -> AnyObject? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getObject(key: key)
    }
    
    public func getInt(key: String, defaultValue: Int) -> Int {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getInt(key: key)
    }
    
    public func getBool(key: String, defaultValue: Bool) -> Bool {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getBool(key: key)
    }
    
    public func getFloat(key: String, defaultValue: Float) -> Float {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getFloat(key: key)
    }
    
    public func getString(key: String, defaultValue: String) -> String? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getString(key: key)
    }
    
    public func getData(key: String, defaultValue: NSData) -> NSData? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getData(key: key)
    }
    
    public func getArray(key: String, defaultValue: NSArray) -> NSArray? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getArray(key: key)
    }
    
    public func getDictionary(key: String, defaultValue: NSDictionary) -> NSDictionary? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getDictionary(key: key)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Set value
    //-------------------------------------------------------------------------------------------
    
    public func setObject(key: String, value: AnyObject?) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    public func setInt(key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func setBool(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func setFloat(key: String, value: Float) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func setString(key: String, value: NSString?) {
        if (value == nil) {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    public func setData(key: String, value: NSData) {
        setObject(key: key, value: value)
    }
    
    public func setArray(key: String, value: NSArray) {
        setObject(key: key, value: value)
    }
    
    
    public func setDictionary(key: String, value: NSDictionary) {
        setObject(key: key, value: value)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Synchronize
    //-------------------------------------------------------------------------------------------
    
    private func Sync() {
        UserDefaults.standard.synchronize()
    }
}
