//
//  CryptoJS.swift
//
//  Created by Emartin on 2015-08-25.
//  Copyright (c) 2015 Emartin. All rights reserved.
//
import Foundation
import JavaScriptCore

private var cryptoJScontext = JSContext()

open class CryptoJS: NSObject{
    
    open class AES: CryptoJS{
        
        fileprivate var encryptFunction: JSValue!
        fileprivate var decryptFunction: JSValue!
        
        override init(){
            super.init()
            
            let bundle = Bundle(for: self.classForCoder)
            let cryptoJSpath = bundle.path(forResource: "aes", ofType: "js")
            
            if(( cryptoJSpath ) != nil){
                do {
                    let cryptoJS = try String(contentsOfFile: cryptoJSpath!, encoding: String.Encoding.utf8)
                    print("Loaded aes.js")
                    
                    // Evaluate aes.js
                    _ = cryptoJScontext?.evaluateScript(cryptoJS)
                    
                    // Reference functions
                    encryptFunction = cryptoJScontext?.objectForKeyedSubscript("encrypt")
                    decryptFunction = cryptoJScontext?.objectForKeyedSubscript("decrypt")
                }
                catch {
                    print("Unable to load aes.js")
                }
            }else{
                print("Unable to find aes.js")
            }
            
        }
        
        open func encrypt(_ secretMessage: String,secretKey: String,options: Any?=nil)->String {
            if let unwrappedOptions: Any = options {
                return "\(encryptFunction.call(withArguments: [secretMessage, secretKey, unwrappedOptions])!)"
            }else{
                return "\(encryptFunction.call(withArguments: [secretMessage, secretKey])!)"
            }
        }
        open func decrypt(_ encryptedMessage: String,secretKey: String,options: Any?=nil)->String {
            if let unwrappedOptions: Any = options {
                return "\(decryptFunction.call(withArguments: [encryptedMessage, secretKey, unwrappedOptions])!)"
            }else{
                return "\(decryptFunction.call(withArguments: [encryptedMessage, secretKey])!)"
            }
        }
        
    }
}
