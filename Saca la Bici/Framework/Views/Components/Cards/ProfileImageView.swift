//
//  ProfileImageView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 09/10/24.
//

import SwiftUI

struct ProfileImageView: View {
    let imageUrlString: String?

    var body: some View {
        if let imageUrlString = imageUrlString, let imageUrl = URL(string: imageUrlString) {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                case .failure:
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
        }
    }
}
