import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct NavbarView: View {
    var body: some View {
        GeometryReader { geometry in
            Text("FestiGames")
                .frame(width: geometry.size.width, height: 80)
                .foregroundColor(Color(red: 0.933, green: 0.933, blue: 0.933, opacity: 1.0))
                .background(Color(red: 0.651, green: 0.294, blue: 0.165, opacity: 1))
                .font(Font.custom("Inter-Bold", size: 24))
        }
    }
}

struct FooterView: View {
    var body: some View {
        Rectangle()
            .frame(height: 80)
            .foregroundColor(Color(red: 0.651, green: 0.294, blue: 0.165, opacity: 1))
    }
}

struct BorderedView<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            NavbarView()
            HStack {
                content
                    .padding(10)
            }
            Spacer()
            FooterView()
        }
    }
}

struct CardView: View, Hashable {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct HorizontalCardListView: View {
    var cards: [CardView]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(cards, id: \.self) { card in
                    card
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BorderedView {
        //    HorizontalCardListView {
                CardView(title: "Test card", subtitle: "Magnificient card")
                CardView(title: "Test card", subtitle: "Magnificient card")
                CardView(title: "Test card", subtitle: "Magnificient card")
//            }
        }
    }
}
