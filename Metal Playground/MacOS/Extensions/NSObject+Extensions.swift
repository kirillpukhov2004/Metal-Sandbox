import AppKit

extension NSObject {
    func bind<Root, Value>(_ binding: NSBindingName, to observable: Root, keyPath: KeyPath<Root, Value>, options: [NSBindingOption: Any]? = nil) {
        guard let kvcKeyPath = keyPath._kvcKeyPathString else {
            fatalError("Unable to bind to key path: \(keyPath)")
        }

        bind(binding, to: observable, withKeyPath: kvcKeyPath, options: options)
    }
}
