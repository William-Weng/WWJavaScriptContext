//
//  JavaScriptContext.swift
//  WWJavaScriptContext
//
//  Created by William.Weng on 2023/8/23.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWJavaScriptContext

import JavaScriptCore

// MARK: - JavaScriptCore小工具
open class WWJavaScriptContext {
    
    private let context = JSContext()
    
    private var nativeFuntions: Set<String> = []
}

// MARK: - public static function
public extension WWJavaScriptContext {
    
    /// [建立執行完成的環境](https://levelup.gitconnected.com/swift-executing-javascript-functions-in-ios-app-using-wkwebview-f905dd1a489)
    /// - Parameter script: String
    /// - Returns: WWJavaScriptContext
    static func build(script: String) -> WWJavaScriptContext {
        
        let javaScript = WWJavaScriptContext()
        javaScript.context?.evaluateScript(script)
        
        return javaScript
    }
}

// MARK: - public function
public extension WWJavaScriptContext {
        
    /// [執行javaScript程式](https://stackoverflow.com/questions/37434560/can-i-run-javascript-inside-swift-code/37435316#37435316)
    /// - Parameters:
    ///   - name: String
    ///   - arguments: [Any]
    /// - Returns: JSValue?
    func callFunctionName(_ name: String, arguments: [Any] = []) -> JSValue? {
        
        guard let context = context,
              let function = context.objectForKeyedSubscript(name)
        else {
            return nil
        }
        
        return function.call(withArguments: arguments)
    }
    
    /// 執行Script
    /// - Parameter script: String
    /// - Returns: JSValue?
    func evaluateScript(_ script: String) -> JSValue? {
        
        guard let context = context,
              let result = context.evaluateScript(script)
        else {
            return nil
        }
        
        return result
    }
    
    /// [建立Swift-function給js用](https://www.appcoda.com.tw/javascriptcore-swift/)
    /// - Parameters:
    ///   - name: String
    ///   - handler: T
    /// - Returns: Bool
    func insertNativeFunctionName<T>(_ name: String, handler: T) -> Bool {
        
        guard let context = context,
              let object = Optional.some(unsafeBitCast(handler, to: AnyObject.self)),
              let key = name as (NSCopying & NSObjectProtocol)?
        else {
            return false
        }
        
        context.setObject(object, forKeyedSubscript: key)
        nativeFuntions.insert(name)
        
        return false
    }
    
    /// 移除Swift-function
    /// - Parameter name: String
    /// - Returns: Bool
    func removeNativeFunctionName(_ name: String) -> Bool {
        
        guard let context = context else { return false }

        let script = "var \(name) = undefined;"
        context.evaluateScript(script)
        nativeFuntions.remove(name)
        
        return true
    }
    
    /// [取得已建立的Swift-Functions](https://zhuanlan.zhihu.com/p/81634837)
    /// - Returns: Set<String>
    func createdNativeFuntions() -> Set<String> { return nativeFuntions }
    
    /// [回應js控制台錯誤](https://waynestalk.com/ios-javascriptcore-tutorial/)
    /// - Parameter handler: (JSContext?, JSValue?) -> Void
    func exceptionHandler(_ handler: @escaping (JSContext?, JSValue?) -> Void) {
        
        guard let context = context else { return }
        
        context.exceptionHandler = { context, exception in
            handler(context, exception)
        }
    }
}
