import Defaults
import SwiftUI

struct FooterView: View {
  @Bindable var footer: Footer

  @Environment(AppState.self) private var appState
  @Environment(ModifierFlags.self) private var modifierFlags
  @Default(.showFooter) private var showFooter
  @State private var clearOpacity: Double = 1
  @State private var clearAllOpacity: Double = 0

  var clearAllModifiersPressed: Bool {
    guard let clearItem = footer.clearItem,
          let clearAllItem = footer.clearAllItem else {
      return false
    }
    let clearModifiers = clearItem.shortcuts.first?.modifierFlags ?? []
    let clearAllModifiers = clearAllItem.shortcuts.first?.modifierFlags ?? []
    return !modifierFlags.flags.isEmpty
      && !modifierFlags.flags.isSubset(of: clearModifiers)
      && modifierFlags.flags.isSubset(of: clearAllModifiers)
  }

  var body: some View {
    VStack(spacing: 0) {
      Divider()
        .padding(.horizontal, Popup.horizontalSeparatorPadding)
        .padding(.bottom, Popup.verticalSeparatorPadding)

      if let pauseItem = footer.pauseItem, pauseItem.isVisible {
        FooterItemView(item: pauseItem)
      }

      if let clearItem = footer.clearItem, let clearAllItem = footer.clearAllItem {
        ZStack {
          FooterItemView(item: clearItem)
            .opacity(clearOpacity)
          FooterItemView(item: clearAllItem)
            .opacity(clearAllOpacity)
        }
      }

      ForEach(footer.standardItems) { item in
        FooterItemView(item: item)
      }
    }
    .onChange(of: appState.searchVisible, initial: true) {
      updatePauseVisibility()
    }
    .onChange(of: modifierFlags.flags, initial: true) {
      updateClearVisibility()
    }
    .opacity(showFooter ? 1 : 0)
    .frame(maxHeight: showFooter ? nil : 0)
    .padding(.bottom, showFooter ? Popup.verticalPadding : 0)
    .readHeight(appState, into: \.popup.footerHeight)
  }

  private func updatePauseVisibility() {
    guard let pauseItem = footer.pauseItem else { return }

    pauseItem.isVisible = !appState.searchVisible

    if !pauseItem.isVisible && appState.footer.selectedItem == pauseItem {
      appState.navigator.select(footerItem: footer.firstVisibleItem)
    }
  }

  private func updateClearVisibility() {
    guard let clearItem = footer.clearItem,
          let clearAllItem = footer.clearAllItem else { return }

    if clearAllModifiersPressed {
      clearOpacity = 0
      clearAllOpacity = 1
      clearItem.isVisible = false
      clearAllItem.isVisible = true
      if appState.footer.selectedItem == clearItem {
        appState.navigator.select(footerItem: clearAllItem)
      }
    } else {
      clearOpacity = 1
      clearAllOpacity = 0
      clearItem.isVisible = true
      clearAllItem.isVisible = false
      if appState.footer.selectedItem == clearAllItem {
        appState.navigator.select(footerItem: clearItem)
      }
    }
  }
}
