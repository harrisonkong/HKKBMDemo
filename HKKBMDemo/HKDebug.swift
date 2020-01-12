//
//  HKDebug.swift
//  HK Debugger
//

///  MIT License
///
///  Copyright (c) 2020 Harrison Kong
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to deal
///  in the Software without restriction, including without limitation the rights
///  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell/
///  copies of the Software, and to permit persons to whom the Software is
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in all
///  copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
///  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
///  SOFTWARE.

//  Version: 1.0.0
//
//  Version History
//  -----------------------------------------------------------------
//  1.0.0     -     initial release

class HKDebug {
  
  // MARK: - Properties
  // MARK: -
  
  public private(set) static var isEnabled = false
  private static var categories : [ String : Bool ] = [ : ]

  // MARK: - Public Methods
  // MARK: -
  
  public static func activateAllCategories() {
    for (key, _) in categories {
      categories[key] = true
    }
  }

  public static func activateCategory(_ key: String) {
    categories[key] = true
  }
  
  public static func deactivateAllCategories() {
    for (key, _) in categories {
      categories[key] = false
    }
  }

  public static func deactivateCategory(_ key: String) {
    categories[key] = false
  }
  
  public static func disable() {
    isEnabled = false
  }
  
  public static func enable() {
    isEnabled = true
  }
  
  public static func listCategories() {
    self.print("-----------------------")
    self.print("[HKDebug Category List]")
    self.print("-----------------------")
    
    for (key, value) in categories {
      self.print("\(key) : \(value ? "enabled" : "disabled")")
    }
    
    self.print("-----------------------")
  }
  
  public static func print(_ anything: Any) {
    if isEnabled {
      Swift.print(String(describing: anything))
    }
  }

  public static func print(_ anything: Any, category key: String) {
    
    if let categoryEnabled = categories[key] {
      if categoryEnabled {
        self.print("[\(key)] \(String(describing: anything))")
      }
    } else {
      self.print("[HKDebug.print()] ***** Warning: unknown category: \(key)")
      self.print("[HKDebug.print()] call HKDebug.activateCategory(\"\(key)\") to add it")
    }
  }
  
  public static func printVersion() {
    self.print("[HKDebug.printVersion()] ***** Version \(version())")
  }
  
  public static func removeCategory(_ key: String) {
    categories[key] = nil
  }
  
  public static func version() -> String {
    return "1.0.0"
  }
}
