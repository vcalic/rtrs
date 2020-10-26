//
//  Strings.swift
//  RTRS
//
//  Created by Vlada Calic on 04/10/2020.
//  Copyright © 2020 Byrccom. All rights reserved.
//

import Foundation

enum MenuStyle {
  case plain, invert
}

private enum Menu {
  case tvUzivo, radioUzivo, vijesti, tv, radio, video, audio, foto, rtrs, kontakt, oAplikaciji, open, close, categories
}

private extension Menu {
  var lat: String {
    switch self {
    case .tvUzivo:
      return "TV uživo"
    case .radioUzivo:
      return "Radio uživo"
    case .vijesti:
      return "Vijesti"
    case .tv:
      return "TV"
    case .radio:
      return "Radio"
    case .video:
      return "Video"
    case .audio:
      return "Audio"
    case .foto:
      return "Foto"
    case .rtrs:
      return "RTRS"
    case .kontakt:
      return "Kontakt"
    case .oAplikaciji:
      return "O aplikaciji"
    case .open:
      return "Otvori"
    case .close:
      return "Zatvori"
    case .categories:
      return "Kategorije"
    }
  }

  var cir: String {
    switch self {
    case .tvUzivo:
      return "TV uživo"
    case .radioUzivo:
      return "Radio uživo"
    case .vijesti:
      return "Вијести"
    case .tv:
      return "ТВ"
    case .radio:
      return "Радио"
    case .video:
      return "Видео"
    case .audio:
      return "Аудио"
    case .foto:
      return "Фото"
    case .rtrs:
      return "РТРС"
    case .kontakt:
      return "Контакт"
    case .oAplikaciji:
      return "О апликацији"
    case .open:
      return "Отвори"
    case .close:
      return "Затвори"
    case .categories:
      return "Категорије"
    }
  }

  var style: MenuStyle {
    switch self {
    case .tvUzivo: return .invert
    case .radioUzivo: return .invert
    default: return .plain
    }
  }
}
