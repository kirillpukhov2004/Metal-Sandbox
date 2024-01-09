import Foundation

struct Size {
    var width: Float
    var height: Float
}

extension Size {
    init(_ cgSize: CGSize) {
        self.init(width: Float(cgSize.width), height: Float(cgSize.height))
    }
}

extension Size {
    var aspectRatio: Float {
        return width / height
    }
}
