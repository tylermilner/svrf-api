/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A type representing the available options for virtual content.
*/

enum VirtualContentType: Int {
    case none
    case faceGeometry
    case faceGeometry2
    case faceGeometry3
    case blendShapeModelIO
    
    static let orderedValues: [VirtualContentType] = [.none, .faceGeometry, .faceGeometry2, faceGeometry3, .blendShapeModelIO]
    
    var imageName: String {
        switch self {
        case .none: return "none"
        case .faceGeometry: return "faceGeometry"
        case .faceGeometry2: return "faceGeometry"
        case .faceGeometry3: return "faceGeometry"
        case .blendShapeModelIO: return "blendShapeModel"
        }
    }
}
