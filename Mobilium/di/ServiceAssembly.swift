//
//  ServiceAssembly.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation
import Foundation
import Swinject

class ServiceAssembly: Assembly {
    private let assembler: Assembler

    init(assembler: Assembler) {
        self.assembler = assembler
    }
    func assemble(container: Container) {
        container.register(SearchServiceProtocol.self) { _ in
            SearchService()
        }.inObjectScope(.container)
    }
}
