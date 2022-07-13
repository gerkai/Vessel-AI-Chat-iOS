// GitHub Repo and Documentation: https://github.com/nteissler/Resolver

import Foundation

/// Use the `@Resolved` property wrapper to avoid `Resolver` boilerplate.
/// - Note: This, like all property wrappers can only be used on properties. If your type
/// only resolves a `Service` in one place, called infrequently, you can still use
/// `let local = Resolver.resolve(MyType.self)` to avoid declaring a property. If your
/// type uses the service multiple times, it should declare the `@Resolved` property
/// to ensure the instance uses the same service each time.
@propertyWrapper
public struct Resolved<Service>: Resolving {

    public init() { }

    /// Once the `Service` is resolved, it isn't resolved again. This prevents behavior from changing
    /// out from under callers in unexpected ways.
    private var service: Service?

    /// `container` is unlikely to be needed in most use cases. It can be use for specific app subflows where
    /// having a completey separate Resolver or injecting a `Resolver` ahead of the `Resolver.main` is
    /// desirable.
    public var container: Resolver?

    /// Use `name` to differentiate between services or protocols of the same type.
    ///
    /// For example, if
    /// a view controller is trying to resolve a view model, there may be two protocols for that view model,
    /// `CurrentDataViewModel` and `PastDataViewModel` that both adopt the `ViewModel` protocol.
    /// Setting the name parameter, controls what is resolved:
    ///
    ///     class ViewController {
    ///         @Resolved private var viewModel: ViewModel
    ///         var showCurrent: Bool = false
    ///
    ///         override viewDidLoad() {
    ///             _viewModel.name = showCurrent ? "current" : "past"
    ///             viewModel.configure(myData)
    ///         }
    ///     }
    ///
    /// You must have registered the two view models previously:
    ///
    ///     func setupMyRegistrations {
    ///         register(name: "current") { CurrentDataViewModel() as ViewModel }
    ///         register(name: "currentLoans") { PastDataViewModel() as ViewModel }
    ///     }
    public var name: String?

    public var wrappedValue: Service {
        mutating get {
            if let resolved = service {
                return resolved
            } else {
                let resolved = resolver.resolve(Service.self, name: name)
                service = resolved
                return resolved
            }
        }
    }

    // MARK: Resolving
    public var resolver: Resolver {
        return container ?? Resolver.root
    }
}
