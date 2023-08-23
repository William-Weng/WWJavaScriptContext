//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2022/12/15.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWJavaScriptContext

import UIKit
import WWJavaScriptContext
import WWPrint

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        simpleDemo()
        addNumbers(num1: 5, num2: 6)
        removeFunction()
    }
}

// MARK: - private function
private extension ViewController {
    
    /// 基本使用
    func simpleDemo() {
        
        let script = "var jsFunc = function(message) { return '測試用訊息：' + message; }"
        let context = WWJavaScriptContext.build(script: script)

        context.exceptionHandler { context, exception in
            if let exception = exception { wwPrint(exception) }
        }
        
        wwPrint(context.callFunctionName("jsFunc", arguments: ["William"]))
    }
    
    /// 兩數相加 (使用Swift自訂Function)
    /// - Parameters:
    ///   - num1: Int
    ///   - num2: Int
    func addNumbers(num1: Int, num2: Int) {
        
        let context = WWJavaScriptContext.build(script: "")
        let addNumbersHandler: @convention(block) (Int, Int) -> Int = { num1, num2 in return num1 + num2 }
                        
        _ = context.insertNativeFunctionName("add", handler: addNumbersHandler)
        wwPrint("自訂function：\(context.createdNativeFuntions())")
        wwPrint(context.callFunctionName("add", arguments: [num1, num2]))
    }
    
    /// 移除自訂function
    func removeFunction() {
        
        let context = WWJavaScriptContext.build(script: "")
        
        context.exceptionHandler { context, exception in
            if let exception = exception { wwPrint(exception) }
        }
        
        _ = context.removeNativeFunctionName("add")
        wwPrint(context.callFunctionName("add", arguments: [1, 2]))
    }
}
