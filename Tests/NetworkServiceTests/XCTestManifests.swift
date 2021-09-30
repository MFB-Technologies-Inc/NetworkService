import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NetworkServiceTests.allTests),
        testCase(PublisherNetworkServicesTests.allTests)
    ]
}
#endif
