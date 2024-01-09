import Cocoa

enum ProjectOutlineItemType {
    case group
    case sceneObject(AnySceneObject)
}

extension ProjectOutlineItemType: Equatable {
    static func == (lhs: ProjectOutlineItemType, rhs: ProjectOutlineItemType) -> Bool {
        switch (lhs, rhs) {
        case (.group, .group):
            return true
        case (.sceneObject(let lhsSceneObject), .sceneObject(let rhsSceneObject)):
            return lhsSceneObject === rhsSceneObject
        default:
            return false
        }
    }
}

struct ProjectOutlineItem {
    var type: ProjectOutlineItemType

    var subitems: [ProjectOutlineItem] = []

    init(type: ProjectOutlineItemType) {
        self.type = type
    }
}
