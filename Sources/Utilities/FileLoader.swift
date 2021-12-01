import Foundation

public class FileLoader {
    public static func load(file: String, extension: String? = nil, directory: String? = nil) -> String {
        guard let path = Bundle.main.path(forResource: file, ofType: `extension`, inDirectory: directory),
              let data = FileManager.default.contents(atPath: path),
              let contents = String(data: data, encoding: .utf8) else {
                  fatalError("File could not be read")
              }
        
        return contents
    }
}
