# NetworkService
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMFB-Technologies-Inc%2FNetworkService%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/MFB-Technologies-Inc/NetworkService)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMFB-Technologies-Inc%2FNetworkService%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/MFB-Technologies-Inc/NetworkService)
[![CI](https://github.com/MFB-Technologies-Inc/NetworkService/actions/workflows/ci.yml/badge.svg)](https://github.com/MFB-Technologies-Inc/NetworkService/actions/workflows/ci.yml)

Reactive wrapper for URLSession using Combine. At its core, the library consist of the `NetworkServiceClient` protocol along with a minimal implementation `NetworkService`.

### TopLevelCodable
A notable convenience the library provides is the `TopLevelCodable` protocol that enables easy encoding and decoding of conforming types. The protocol associates a `TopLevelEncoder` and `TopLevelDecoder` with a given type so that it is used by the library without explicitly passing it as a parameter. Additionally, `TopLevelEncodable` and `TopLevelDecodable` are included.

### Basic Usage
```swift
import NetworkService
let networkService = NetworkService()
let url = URL(string: "http://www.foobar.com")!
struct Foo: TopLevelCodable {
    static var encoder: JSONEncoder { JSONEncoder() }
    static var decoder: JSONDecoder { JSONDecoder() }
    let bar: Int
}
let foo = Foo(bar: 0)
```
#### GET
```swift
let publisher: AnyPublisher<Foo, Failuer> = networkService.get(url)
let cancellable = publisher.assertNoFailure().sink { foo in
    print(foo.bar)
}
```

#### POST
```swift
let publisher: AnyPublisher<Foo, Failuer> = networkService.post(foo, to: url)
let cancellable = publisher.assertNoFailure().sink { foo in
    print(foo.bar)
}
```

#### PUT
```swift
let publisher: AnyPublisher<Foo, Failuer> = networkService.put(foo, to: url)
let cancellable = publisher.assertNoFailure().sink { foo in
    print(foo.bar)
}
```

#### DELETE
```swift
let publisher: AnyPublisher<Foo, Failuer> = networkService.get(url)
let cancellable = publisher.assertNoFailure().sink { _ in }
```

#### Start
```swift
var request = URLRequest(url: url)
request.method = .GET
let publisher: AnyPublisher<Foo, Failuer> = networkService.start(request)
let cancellable = publisher.assertNoFailure().sink { foo in
    print(foo.bar)
}
```
## NetworkServiceTestHelper

Provides `MockNetworkService` which is an implementation of `NetworkServiceClient` for testing. Supports defining set output values for all network functions, repeating values, and delaying responses.

## Installation
 Currently, only Swift Package Manager is supported.
