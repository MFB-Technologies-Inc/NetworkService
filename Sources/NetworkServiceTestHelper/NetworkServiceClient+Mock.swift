//
//  File.swift
//  
//
//  Created by andrew on 5/31/24.
//

#if canImport(Combine)
import Combine
import NetworkService

extension NetworkServiceClient {
    public static func mock<T>(_ client: MockNetworkService<T>) -> Self where T: Scheduler, T: Sendable {
        NetworkServiceClient(start: { request, body, _ in await client.start(request, body: body) })
    }
}
#endif
