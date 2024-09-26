//
//  ActividadesAPIService.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import Alamofire
import Foundation

class APIService {
    
    func fetchRodadas(url: URL) async throws -> [RodadasResponse] {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate()
                .responseDecodable(of: [RodadasResponse].self) { response in
                    switch response.result {
                    case .success(let rodadas):
                        continuation.resume(returning: rodadas)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
