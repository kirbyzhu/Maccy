import SwiftUI

@Observable
class FooterItem: Equatable, Identifiable, HasVisibility {
  enum Role: Equatable {
    case pause
    case clear
    case clearAll
    case preferences
    case about
    case quit
  }

  struct Confirmation {
    var message: LocalizedStringKey
    var comment: LocalizedStringKey
    var confirm: LocalizedStringKey
    var cancel: LocalizedStringKey
  }

  static func == (lhs: FooterItem, rhs: FooterItem) -> Bool {
    return lhs.id == rhs.id
  }

  let id = UUID()

  var role: Role?
  var title: String
  var shortcuts: [KeyShortcut] = []
  var help: LocalizedStringKey?
  var isSelected: Bool = false
  var confirmation: Confirmation?
  var showConfirmation: Bool = false
  var suppressConfirmation: Binding<Bool>?
  var isVisible: Bool = true
  var action: () -> Void

  init(
    role: Role? = nil,
    title: String,
    shortcuts: [KeyShortcut] = [],
    help: LocalizedStringKey? = nil,
    confirmation: Confirmation? = nil,
    suppressConfirmation: Binding<Bool>? = nil,
    isVisible: Bool = true,
    action: @escaping () -> Void
  ) {
    self.role = role
    self.title = title
    self.shortcuts = shortcuts
    self.help = help
    self.confirmation = confirmation
    self.suppressConfirmation = suppressConfirmation
    self.isVisible = isVisible
    self.action = action
  }
}
