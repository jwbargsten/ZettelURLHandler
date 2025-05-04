//
//  ZettelURLHandlerApp.swift
//  ZettelURLHandler
//
//  Created by Joachim Bargsten on 04/01/2023.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
  func application(_: NSApplication, open urls: [URL]) {
    guard let conf = try? loadConfig(path: getConfigFilePath()) else { return }

    guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "org.alacritty")
    else { return }
    let configuration = NSWorkspace.OpenConfiguration()
    configuration.createsNewApplicationInstance = true
    //print(urls)
    guard let (kasten, zid, target) = urls.first.flatMap({ extractZettelLocation(url: $0) }) else { return }

    guard let zhome = conf.kasten[kasten] else { return }


      if target ?? "" == "material" {
          let zettelMaterial = "\(zhome)/docs/\(zid)/"
          let zettelMaterialUrl = URL(filePath: zettelMaterial)
          //print(zettelMaterial)
          do {
              if !FileManager.default.fileExists(atPath: zettelMaterial) {
                  try FileManager.default.createDirectory(at: zettelMaterialUrl, withIntermediateDirectories: false)
              }
              NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: zettelMaterial)
              //showInFinder(url: url)
          } catch {
              print("could not create dir \(zettelMaterial): \(error)")
          }
          
      } else {
          let zettelAbs = "\(zhome)/docs/\(zid).md"

          configuration.arguments = ["-e", conf.nvim, zettelAbs]
            configuration.environment = ["ZETTEL_HOME": zhome, "ZETTEL_BASE_URL": "http://localhost:8001/\(kasten)"]
          NSWorkspace.shared.openApplication(at: url, configuration: configuration, completionHandler: nil)
      }

  }
}
// https://stackoverflow.com/questions/30738052/show-folders-contents-in-finder-using-swift
func showInFinder(url: URL?) {
    guard let url = url else { return }
    
    if url.isDirectory {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
    } else {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

extension URL {

    ///IMPORTANT: this code return false even if file or directory does not exist(!!!)
    var isDirectory: Bool {
        hasDirectoryPath
    }
}
