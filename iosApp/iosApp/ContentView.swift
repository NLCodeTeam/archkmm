import SwiftUI
import shared


struct ContentView: View {
    @EnvironmentObject var router: Router
    
    let numTabs = 3
    let minDragTranslationForSwipe: CGFloat = 50
    
    var body: some View {
        
        TabView(selection: $router.selectedTab) {
            
            TabItem(tab: Tab.dashboard)
                .tag(Tab.dashboard)
                .tabItem {
                    Label("Dashboard", systemImage: "star")
                }
            
            TabItem(tab: Tab.news)
                .tag(Tab.news)
                .tabItem {
                    //Label("News", systemImage: "newspaper")
                    
                    ZStack {
                        VStack(spacing:0) {
                            ItemIcon(
                                loading: loading,
                                iconName: iconName,
                                iconSelectedName: iconSelectedName,
                                hasNotify: hasNotify,
                                tint: tint,
                                selected: selected
                            )
                            if let labelString = label {
                                ItemLabel(loading: loading, label: labelString, tint: tint)
                            }
                        }
                        if ripple {
                            RippleView(maxSize: 104, tint: Palette.primary.purple)
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .onTapGesture {
                            if (!loading) {
                                ripple.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { ripple.toggle() }
                                onTap()
                            }
                        }
                }
            
            TabItem(tab: Tab.profile)
                .tag(Tab.profile)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }.highPriorityGesture(DragGesture().onEnded({
            self.handleSwipe(translation: $0.translation.width)
        }))
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation > minDragTranslationForSwipe && router.selectedTab.rawValue > 0 {
            let next = router.selectedTab.rawValue - 1
            router.selectedTab = Tab(rawValue: next)!
            
        } else  if translation < -minDragTranslationForSwipe && router.selectedTab.rawValue < numTabs - 1 {
            let next = router.selectedTab.rawValue + 1
            router.selectedTab = Tab(rawValue: next)!
        }
    }
}

private struct ItemIcon: View {
    let loading: Bool
    let iconName: String
    let iconSelectedName: String?
    let hasNotify: Bool
    let tint: Color
    let selected: Bool
    
    var body: some View {
        if (loading) {
            FakeItemIcon(loading: loading)
        } else {
            RealItemIcon(
                loading: loading,
                iconName: iconName,
                iconSelectedName: iconSelectedName,
                hasNotify: hasNotify,
                tint: tint,
                selected: selected
            )
        }
    }
}

private struct FakeItemIcon: View {

    @Environment (\.colorScheme) var colorScheme: ColorScheme

    let loading: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 24, height: 24, alignment: .center)
                .foregroundColor(colorScheme == .dark ? Color.gray : Color.secondary)
                .shimmering()
        }.frame(width: 48, height: 28, alignment: .center)
    }
}

private struct RealItemIcon: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    let loading: Bool
    let iconName: String
    let iconSelectedName: String?
    let hasNotify: Bool
    let tint: Color
    let selected: Bool
    
    var body: some View {
        ZStack {
            if selected, let iconSelectedName = iconSelectedName {
                Image(iconSelectedName)
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
            } else {
                Image(iconName)
                    .resizable()
                    //.tint(tint: tint)
                    .frame(width: 24, height: 24, alignment: .center)
            }
            if (hasNotify) {
                Circle()
                    .strokeBorder(
                        colorScheme == .dark ? Color.gray : Color.secondary,
                        lineWidth: 2
                    )
                    .background(
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 7.6, height: 7.6, alignment: .center)
                    )
                    .frame(width: 11.6, height: 11.6)
                    .offset(x: 10.3, y: -8.8)
            }
        }.frame(width: 48, height: 28, alignment: .center)
    }
}

private struct ItemLabel: View {
    let loading: Bool
    let label: String
    let tint: Color
    
    var body: some View {
        if (loading) {
            FakeItemLabel(loading: loading)
        } else {
            RealItemLabel(loading: loading, label: label, tint: tint)
        }
    }
}

private struct FakeItemLabel: View {

    @Environment (\.colorScheme) var colorScheme: ColorScheme

    let loading: Bool
    var body: some View {
        Spacer().frame(height: 9)
        RoundedRectangle(cornerRadius: 5).frame(width: 38, height: 5)
            .foregroundColor(colorScheme == .dark ? Color.gray : Color.secondary)
                .shimmering()
        Spacer()
    }
}

private struct RealItemLabel: View {
    let loading: Bool
    let label: String
    let tint: Color
    
    var body: some View {
        Spacer().frame(height: 4)
        Text(label)
        Spacer().frame(height: 3)
    }
}

struct RippleView: View {
    @State private var isHidden = false
    @State private var size: CGFloat = 50
    
    let maxSize: CGFloat
    var tint: Color = Color.accentColor
    
    var body: some View {
        Circle()
            .fill(tint.opacity(isHidden ? 0 : 0.5))
            .frame(width: size, height: size)
            .transition(.opacity)
            .animation(.easeOut(duration: 0.5))
            .onAppear {
                withAnimation {
                    isHidden = true
                    size = maxSize
                }
            }
    }
}

public struct ShimmerView: View {
    @State var show: Bool = false
    
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    let speed: Double
    let angle: Angle
    
    var gradient: LinearGradient {
        let leading = Gradient.Stop(color: .clear, location: 0.35)
        let center = Gradient.Stop(color: (
            colorScheme == .dark ? Color.gray : Color.secondary
        ).opacity(0.7), location: 0.45)
        let trailing = Gradient.Stop(color: .clear, location: 0.55)
        
        return LinearGradient(
            gradient: .init(stops: [leading, center, trailing]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var animation: Animation {
        Animation
            .default
            .speed(0.15)
            .delay(0)
            .repeatForever(autoreverses: false)
    }
    
   public var body: some View {
        GeometryReader { geo in
            Color.white
                .mask(Rectangle().fill(self.gradient))
                .padding(-self.calcSize(geo))
                .rotationEffect(self.angle)
                .offset(x: self.calcOffset(geo), y: 0)
                .animation(self.animation)
        }.onAppear {
            self.show.toggle()
        }
    }
    
    init(speed: Double, angle: Angle) {
        self.speed = speed
        self.angle = angle
    }
    
    func calcOffset(_ geo: GeometryProxy) -> CGFloat {
        let size = calcSize(geo)
        return (self.show ? size : -size) * 2
    }
    
    func calcSize(_ geo: GeometryProxy) -> CGFloat {
        return max(geo.size.width, geo.size.height)
    }
}

// ShimmerModifier
public struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    let speed: Double
    let angle: Angle
    
    public func body(content: Content) -> some View {
        if !isActive { return AnyView(content) }
        
        let view = content
            .overlay(
                ShimmerView(
                    speed: speed,
                    angle: angle
                ).mask(content)
            )
        
        return AnyView(view)
    }
    
    public init(
         isActive: Bool,
         speed: Double,
         angle: Angle
    ) {
         self.isActive = isActive
         self.speed = speed
         self.angle = angle
     }
}

extension View {
    
   public func shimmering(
        isActive: Bool = true,
        speed: Double = 0.15,
        angle: Angle = .init(degrees: 70)
    ) -> some View {
        
        let view = ShimmerModifier(
            isActive: isActive,
            speed: speed,
            angle: angle
        )
        
        return self.modifier(view)
    }
    
}

/**extension ContentView {
    
    private func tabSelection() -> Binding<Tab> {
        Binding { //this is the get block
            self.selectedTab
        } set: { tappedTab in
            if tappedTab == self.selectedTab {
                //User tapped on the tab twice == Pop to root view
                if dashboardNavigationStack.isEmpty {
                    //User already on home view, scroll to top
                } else {
                    dashboardNavigationStack = []
                }
            }
            //Set the tab to the tabbed tab
            self.selectedTab = tappedTab
        }
    }
} **/

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

public extension Image {
    @ViewBuilder func tint(color: Color?) -> some View {
        if let tint = color {
            self.renderingMode(.template).foregroundColor(tint)
        } else {
            self
        }
    }
    
    @ViewBuilder func tintIf(condition: Bool, color: Color) -> some View {
        if condition {
            self.tint(color: color)
        } else {
            self
        }
    }
}

