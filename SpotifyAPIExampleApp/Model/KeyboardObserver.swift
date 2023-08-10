//
//  KeyboardObserver.swift
//  SpotifyAPIExampleApp
//
//  Created by Ankur Ahir on 8/9/23.
//

import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var isVisible = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification in
                notification.name == UIResponder.keyboardWillShowNotification ? true : false
            }
            .assign(to: \.isVisible, on: self)
            .store(in: &cancellables)
    }
}
