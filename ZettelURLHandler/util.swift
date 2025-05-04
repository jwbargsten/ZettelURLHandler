//
//  util.swift
//  ZettelURLHandler
//
//  Created by Joachim Bargsten on 04/01/2023.
//

import Foundation
public func extractZettelLocation(url: URL) -> (String, String, String?)? {
  if url.scheme != "zettel" {
    return nil
  }
  let validNameRegex = #/^\w+$/#
  let host = url.host
  let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
  let target = components?.queryItems?.first(where: { $0.name == "target" })?.value
  let parts = url.pathComponents
  if parts.count == 2, parts.first == "/", parts.last?.contains(validNameRegex) ?? false,
     host?.contains(validNameRegex) ?? false,
     host?.count ?? 1 < 256,
     parts.last?.count ?? 1 < 256,
     target?.count ?? 1 < 256 
  {
    return (host ?? "", parts.last ?? "", target)
  }
  return nil

//    if let match = try? #/^zettel:\/\/(\w+)/(\w+)$/#.firstMatch(in:  url.absoluteString) {
//        let (_, zrepo, zid) = match.output
//        return (String(zrepo), String(zid))
//    }
//    return nil
}

import Yams
struct Kasten {
  var root: String
}

struct ZettelConf: Codable {
  var nvim: String
  var kasten: [String: String]
}

func loadConfig(path: URL) throws -> ZettelConf? {
  let data = try Data(contentsOf: path)

  let decoder = YAMLDecoder()
  return String(data: data, encoding: .utf8).flatMap {
    try? decoder.decode(ZettelConf.self, from: $0)
  }
}

func getConfigFilePath() throws -> URL {
  let x = ProcessInfo.processInfo.environment["XDG_CONFIG_HOME"]
    .flatMap { URL(fileURLWithPath: $0) } ?? FileManager.default.homeDirectoryForCurrentUser
  return x.appending(components: ".config", "zettel.yaml")
}
