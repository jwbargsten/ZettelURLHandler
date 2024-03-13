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
    print(urls)
    guard let (kasten, zid) = urls.first.flatMap({ extractZettelLocation(url: $0) }) else { return }

    guard let zhome = conf.kasten[kasten] else { return }

    let zettelAbs = "\(zhome)/docs/\(zid).md"

    configuration.arguments = ["-e", conf.nvim, zettelAbs]
      configuration.environment = ["ZETTEL_HOME": zhome, "ZETTEL_BASE_URL": "http://localhost:8001/\(kasten)"]
    NSWorkspace.shared.openApplication(at: url, configuration: configuration, completionHandler: nil)
  }
}
