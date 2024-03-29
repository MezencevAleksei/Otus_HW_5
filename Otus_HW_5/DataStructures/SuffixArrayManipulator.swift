//
//  SuffixArrayManipulator.swift
//  Otus_HW_4
//
//  Created by alex on 10/07/2019.
//  Copyright © 2019 Mezencev Aleksei. All rights reserved.
//

import Foundation


open class SuffixArrayManipulator: SuffixArrayManipulatorProtocol {

    
    
    fileprivate var array = [(suffix:String,algo:String)]()
    private let strGen = Services.stringGenerator
    private let newStringLenth:Int = 10
    
    func setupSuffixArray() -> TimeInterval {
        let time = Profiler.runClosureForTime() {
            self.array = self.createArray()
        }
        return time
    }
    
    open func arrayHasObjects() -> Bool {
        if array.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    private func createArray()->[(suffix:String,algo:String)] {
        
        var _array = [(suffix:String,algo:String)]()
        for str in AlgoProvider().all {
            addSuffixToArrayFrom(string: str, _array: &_array, sort: false)
        }
        _array.sort { $0.suffix > $1.suffix }
        return _array
    }
    
    private func addSuffixToArrayFrom(string: String, _array: inout [(suffix:String,algo:String)],sort: Bool){
        for suffix in SuffixSequence(string:string){
            _array.append((suffix: String(suffix), algo: string))
        }
        if sort {
            _array.sort { $0.suffix > $1.suffix }
        }
    }
    
    
    private func findStringInSuffixArray(string:String)->[String]{
        let findArray = array.filter{ var result = false
                                      if $0.suffix.count >= string.count
                                        {result = $0.suffix.lowercased().contains(string.lowercased())}
                                      else if $0.suffix.count < string.count
                                        {result = false}
                                      return result
                                     }.map{$0.suffix}
        return findArray
    }

    open func insertNewObject() -> TimeInterval {
       
        let newString = self.strGen.generateRandomString(self.newStringLenth)
        
        let time = Profiler.runClosureForTime() {
            self.addSuffixToArrayFrom(string: newString, _array: &self.array, sort: true)
        }

        return time
    }
    
    func lookupByObject(_ string: String = "" ) -> TimeInterval {
        var elementForSearch:String
        if string == "" {
            elementForSearch = self.strGen.generateRandomString(3)
        }else{
            elementForSearch = string
        }
        
        let time = Profiler.runClosureForTime() {
            let _ = self.findStringInSuffixArray(string: elementForSearch)
        }
        
        return time
    }
    
    func lookupByObject() -> TimeInterval {
        return lookupByObject("")
    }
    
    func lookupBy10RandomeString() ->TimeInterval {
        var time: TimeInterval = 0
        for _ in 0...10 {
            time = time + lookupByObject()
        }
        return time
    }
    
    func lookupAllAlgo() ->TimeInterval {
        var time: TimeInterval = 0
        for algoName in AlgoProvider().all {
            time = time + lookupByObject(algoName)
        }
        return time
    }
    
    func lookupForSpecifiedNumber(_ countNumb:Int)->TimeInterval{
        let time = Profiler.runClosureForTime() {
            var lookupCount:Int = 0
        
            while countNumb > lookupCount {
                let elementForSearch = self.strGen.generateRandomString(3)
                let result = self.findStringInSuffixArray(string: elementForSearch)
                if result.count > 0 {
                    lookupCount = lookupCount + 1
                }
            }
        }
        return time
    }
}
