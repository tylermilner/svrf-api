/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A type representing the available options for virtual content.
*/

enum VirtualContentType: Int {
    case none
    case faceFilter
    case modelIO
    
    static let orderedValues: [VirtualContentType] = [.none, .faceFilter, .modelIO]
    
    var imageName: String {
        switch self {
        case .none: return "none"
        case .faceFilter: return "faceGeometry"
        case .modelIO: return "blendShapeModel"
        }
    }
}
