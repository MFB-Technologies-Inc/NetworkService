// NetworkServiceClient+Mock.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

#if canImport(Combine)
    import Combine
    import NetworkService

    extension NetworkServiceClient {
        public static func mock(_ client: MockNetworkService<some Scheduler & Sendable>) -> Self {
            NetworkServiceClient(start: { request, body, _ in await client.start(request, body: body) })
        }
    }
#endif
