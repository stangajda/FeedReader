//
//  AssemblyProtocol.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation
import Swinject

protocol AssemblyProtocol: Assembly {
    
}

//MARK:- Register
extension AssemblyProtocol {
    func register<Service>(_ serviceType: Service.Type, container: Container, name: Injection.Name, _ factory: @escaping (Resolver) -> Service ){
        container.register(serviceType, name: name.rawValue, factory: factory)
    }
}
