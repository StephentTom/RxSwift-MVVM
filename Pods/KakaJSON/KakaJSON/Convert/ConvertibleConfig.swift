//
//  ConvertibleConfig.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/15.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

public typealias ModelKeyConfig = (Property) -> ModelPropertyKey
public typealias ModelValueConfig = (Any?, Property) -> Any?
public typealias JSONKeyConfig = (Property) -> JSONPropertyKey
public typealias JSONValueConfig = (Any?, Property) -> Any?

/// Config for convertible
public class ConvertibleConfig {
    private static let lock = DispatchSemaphore(value: 1)
    private class Item {
        var modelKey: ModelKeyConfig?
        var modelValue: ModelValueConfig?
        var jsonKey: JSONKeyConfig?
        var jsonValue: JSONValueConfig?
        init() {}
        init(modelKey: @escaping ModelKeyConfig) { self.modelKey = modelKey }
        init(modelValue: @escaping ModelValueConfig) { self.modelValue = modelValue }
        init(jsonKey: @escaping JSONKeyConfig) { self.jsonKey = jsonKey }
        init(jsonValue: @escaping JSONValueConfig) { self.jsonValue = jsonValue }
    }
    
    private static let global: Item = Item()
    private static var items: [TypeKey: Item] = [:]
    
    /// get global config for modelKey
    public static func modelKey(from property: Property) -> ModelPropertyKey {
        lock.wait()
        defer { lock.signal() }
        guard let fn = global.modelKey else { return property.name }
        return fn(property)
    }
    
    /// get model's config for modelKey
    public static func modelKey(from property: Property,
                                _ model: Convertible) -> ModelPropertyKey {
        return modelKey(from: property, type(of: model))
    }
    
    /// get type's config for modelKey
    public static func modelKey(from property: Property,
                                _ type: Convertible.Type) -> ModelPropertyKey {
        lock.wait()
        defer { lock.signal() }
        
        if let fn = items[typeKey(type)]?.modelKey {
            return fn(property)
        }
        
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.modelKey {
                    return fn(property)
                }
                classMt = superMt
            }
        }
        
        guard let fn = global.modelKey else { return property.name }
        return fn(property)
    }
    
    /// get global config for modelValue
    public static func modelValue(from jsonValue: Any?,
                                  _ property: Property) -> Any? {
        lock.wait()
        defer { lock.signal() }
        guard let fn = global.modelValue else { return jsonValue }
        return fn(jsonValue, property)
    }
    
    /// get model's config for modelValue
    public static func modelValue(from jsonValue: Any?,
                                  _ property: Property,
                                  _ model: Convertible) -> Any? {
        return modelValue(from: jsonValue, property, type(of: model))
    }
    
    /// get type's config for modelValue
    public static func modelValue(from jsonValue: Any?,
                                  _ property: Property,
                                  _ type: Convertible.Type) -> Any? {
        lock.wait()
        defer { lock.signal() }
        
        if let fn = items[typeKey(type)]?.modelValue {
            return fn(jsonValue, property)
        }
        
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.modelValue {
                    return fn(jsonValue, property)
                }
                classMt = superMt
            }
        }
        
        guard let fn = global.modelValue else { return jsonValue }
        return fn(jsonValue, property)
    }
    
    /// get global config for JSONKey
    public static func JSONKey(from property: Property) -> JSONPropertyKey {
        lock.wait()
        defer { lock.signal() }
        
        guard let fn = global.jsonKey else { return property.name }
        return fn(property)
    }
    
    /// get model's config for JSONKey
    public static func JSONKey(from property: Property,
                               _ model: Convertible) -> JSONPropertyKey {
        return JSONKey(from: property, type(of: model))
    }
    
    /// get type's config for JSONKey
    public static func JSONKey(from property: Property,
                               _ type: Convertible.Type) -> JSONPropertyKey {
        lock.wait()
        defer { lock.signal() }
        
        if let fn = items[typeKey(type)]?.jsonKey {
            return fn(property)
        }
        
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.jsonKey {
                    return fn(property)
                }
                classMt = superMt
            }
        }
        
        guard let fn = global.jsonKey else { return property.name }
        return fn(property)
    }
    
    /// get global config for JSONValue
    public static func JSONValue(from modelValue: Any?,
                                 _ property: Property) -> Any? {
        lock.wait()
        defer { lock.signal() }
        
        guard let fn = global.modelValue else { return modelValue }
        return fn(modelValue, property)
    }
    
    /// get model's config for JSONValue
    public static func JSONValue(from modelValue: Any?,
                                 _ property: Property,
                                 _ model: Convertible) -> Any? {
        return JSONValue(from: modelValue, property, type(of: model))
    }
    
    /// get type's config for JSONValue
    public static func JSONValue(from modelValue: Any?,
                                 _ property: Property,
                                 _ type: Convertible.Type) -> Any? {
        lock.wait()
        defer { lock.signal() }
        
        if let fn = items[typeKey(type)]?.jsonValue {
            return fn(modelValue, property)
        }
        
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.jsonValue {
                    return fn(modelValue, property)
                }
                classMt = superMt
            }
        }
        
        guard let fn = global.modelValue else { return modelValue }
        return fn(modelValue, property)
    }
    
    /// set type's config for modelKey
    public static func setModelKey(for type: Convertible.Type,
                                   _ modelKey: @escaping ModelKeyConfig) {
        setModelKey(for: [type], modelKey)
    }
    
    /// set types's config for modelKey
    public static func setModelKey(for types: [Convertible.Type] = [],
                                   _ modelKey: @escaping ModelKeyConfig) {
        lock.wait()
        defer { lock.signal() }
        
        // clear model key cache
        Metadata.modelTypes.forEach { $0.clearModelKeys() }
        
        if types.count == 0 {
            global.modelKey = modelKey
            return
        }
        
        types.forEach {
            let key = typeKey($0)
            if let item = items[key] {
                item.modelKey = modelKey
                return
            }
            items[key] = Item(modelKey: modelKey)
        }
    }
    
    /// set type's config for modelValue
    public static func setModelValue(for type: Convertible.Type,
                                     modelValue: @escaping ModelValueConfig) {
        setModelValue(for: [type], modelValue: modelValue)
    }
    
    /// set types's config for modelValue
    public static func setModelValue(for types: [Convertible.Type] = [],
                                     modelValue: @escaping ModelValueConfig) {
        lock.wait()
        defer { lock.signal() }
        
        if types.count == 0 {
            global.modelValue = modelValue
            return
        }
        
        types.forEach {
            let key = typeKey($0)
            if let item = items[key] {
                item.modelValue = modelValue
                return
            }
            items[key] = Item(modelValue: modelValue)
        }
    }
    
    /// set type's config for jsonKey
    public static func setJSONKey(for type: Convertible.Type,
                                  jsonKey: @escaping JSONKeyConfig) {
        setJSONKey(for: [type], jsonKey: jsonKey)
    }
    
    /// set types's config for jsonKey
    public static func setJSONKey(for types: [Convertible.Type] = [],
                                  jsonKey: @escaping JSONKeyConfig) {
        lock.wait()
        defer { lock.signal() }
        
        // clear JSON key cache
        Metadata.modelTypes.forEach { $0.clearJSONKeys() }
        
        if types.count == 0 {
            global.jsonKey = jsonKey
            return
        }
        
        types.forEach {
            let key = typeKey($0)
            if let item = items[key] {
                item.jsonKey = jsonKey
                return
            }
            items[key] = Item(jsonKey: jsonKey)
        }
    }
    
    /// set type's config for jsonValue
    public static func setJSONValue(for type: Convertible.Type,
                                    jsonValue: @escaping JSONValueConfig) {
        setJSONValue(for: [type], jsonValue: jsonValue)
    }
    
    /// set types's config for jsonValue
    public static func setJSONValue(for types: [Convertible.Type] = [],
                                    jsonValue: @escaping JSONValueConfig) {
        lock.wait()
        defer { lock.signal() }
        
        if types.count == 0 {
            global.jsonValue = jsonValue
            return
        }
        
        types.forEach {
            let key = typeKey($0)
            if let item = items[key] {
                item.jsonValue = jsonValue
                return
            }
            items[key] = Item(jsonValue: jsonValue)
        }
    }
}
