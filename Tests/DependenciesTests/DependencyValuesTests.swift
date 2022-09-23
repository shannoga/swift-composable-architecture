import ComposableArchitecture
import XCTest

private extension DependencyValues {
  var missingLiveDependency: Int {
    get { self[TestKey.self] }
    set { self[TestKey.self] = newValue }
  }
}

private enum TestKey: TestDependencyKey {
  static let testValue = 42
}

final class DependencyValuesTests: XCTestCase {
  func testMissingLiveValue() {
    var line: UInt = 0

    XCTExpectFailure {
      $0.compactDescription == """
        @Dependency(\\.missingLiveDependency) has no live implementation, but was accessed from a \
        live context.

          Location:
            DependenciesTests/DependencyValuesTests.swift:\(line)
          Key:
            TestKey
          Value:
            Int

        Every dependency registered with the library must conform to 'DependencyKey', and that \
        conformance must be visible to the running application.

        To fix, make sure that 'TestKey' conforms to 'DependencyKey' by providing a live \
        implementation of your dependency, and make sure that the conformance is linked with this \
        current application.
        """
    }

    line = #line + 1
    @Dependency(\.missingLiveDependency) var missingLiveDependency: Int
    _ = missingLiveDependency
  }
}
