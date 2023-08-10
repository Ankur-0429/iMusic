//
//  LogoutButton.swift
//  SpotifyAPIExampleApp
//
//  Created by Ankur Ahir on 8/9/23.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var spotify: Spotify
    var body: some View {
        Button(action: spotify.api.authorizationManager.deauthorize, label: {
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding(7)
                        .background(Color(#colorLiteral(red: 0.3923448698, green: 0.7200681584, blue: 0.19703095, alpha: 1)))
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    
                })
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButton()
    }
}
