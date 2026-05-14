import WidgetKit
import SwiftUI

// MARK: - Shared data model

struct TaggedState: Codable {
    let isIt: Bool
    let itName: String
    
    static let placeholder = TaggedState(isIt: false, itName: "Bill")
    
    static func load() -> TaggedState {
        let defaults = UserDefaults(suiteName: AppConfig.appGroupId)
        guard
            let jsonString = defaults?.string(forKey: "tagged_state"),
            let data = jsonString.data(using: .utf8),
            let state = try? JSONDecoder().decode(TaggedState.self, from: data)
        else {
            return .placeholder
        }
        return state
    }
}

enum AppConfig {
    // Must match the App Group ID you set up in Xcode + the Flutter side
    static let appGroupId = "group.it-widget"
    // Must match your iOS URL scheme registered in Info.plist
    static let urlScheme = "billtaunter"
}

// MARK: - Timeline

struct TaggedEntry: TimelineEntry {
    let date: Date
    let state: TaggedState
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaggedEntry {
        TaggedEntry(date: Date(), state: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (TaggedEntry) -> Void) {
        completion(TaggedEntry(date: Date(), state: TaggedState.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TaggedEntry>) -> Void) {
        let entry = TaggedEntry(date: Date(), state: TaggedState.load())
        // .never = system will not auto-refresh; only updates on explicit reload
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

// MARK: - Pill Button (unchanged)

enum PillButtonSize {
    case small, medium, large
    
    var fontSize: CGFloat {
        switch self {
        case .small: 14
        case .medium: 18
        case .large: 22
        }
    }
    var verticalPadding: CGFloat {
        switch self { case .small: 8; case .medium: 12; case .large: 16 }
    }
    var horizontalPadding: CGFloat {
        switch self { case .small: 22; case .medium: 28; case .large: 32 }
    }
    var lipOffset: CGFloat {
        switch self { case .small: 3; case .medium: 4; case .large: 5 }
    }
}

struct PillButtonLabel: View {
    let title: String
    var size: PillButtonSize = .medium
    var isPressed: Bool = false
    
    private let pinkTop = Color(red: 212/255, green: 91/255, blue: 133/255)
    private let pinkBottom = Color(red: 169/255, green: 61/255, blue: 107/255)
    
    var body: some View {
        Text(title)
            .font(.custom("DMSans-9ptRegular", size: size.fontSize))
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .background(
                ZStack {
                    Capsule().fill(pinkBottom).offset(y: isPressed ? 1 : size.lipOffset)
                    Capsule().fill(pinkTop).offset(y: isPressed ? size.lipOffset - 1 : 0)
                }
            )
            .animation(.spring(response: 0.18, dampingFraction: 0.55), value: isPressed)
    }
}

// MARK: - Widget views

struct widgetsEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        if entry.state.isIt {
            YouAreItView()
        } else {
            SomeoneElseIsItView(itName: entry.state.itName)
        }
    }
}

struct YouAreItView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("You're")
                .font(.custom("Caprasimo-Regular", size: 30))
                .foregroundStyle(.white)
            Text("It!")
                .font(.custom("Caprasimo-Regular", size: 48))
                .foregroundStyle(.white)
            
        }
    }
}

struct SomeoneElseIsItView: View {
    let itName: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(itName)
                .font(.custom("Caprasimo-Regular", size: 28))
                .foregroundStyle(.black)
            
            Text("Is It!")
                .font(.custom("Caprasimo-Regular", size: 28))
                .foregroundStyle(.black)
            
            Link(destination: URL(string: "/taunt")!) {
                PillButtonLabel(title: "Taunt \(itName)", size: .small)
            }
        }
    }
}

// MARK: - Color hex helper (unchanged)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: 1.0)
    }
}

// MARK: - Widget configuration

struct widgets: Widget {
    let kind: String = "widgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                widgetsEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        entry.state.isIt
                            ? Color(hex: "f46197")   // blue when you're it
                            : Color(hex: "D7F6E1")   // mint when someone else is it
                    }
            } else {
                widgetsEntryView(entry: entry)
                    .padding()
                    .background(
                        entry.state.isIt
                            ? Color(hex: "f46197")
                            : Color(hex: "D7F6E1")
                    )
            }
        }
        .configurationDisplayName("IT! Preview")
        .description("Easily glance to see whose it!")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    widgets()
} timeline: {
    TaggedEntry(date: .now, state: TaggedState(isIt: false, itName: "Bill"))
    TaggedEntry(date: .now, state: TaggedState(isIt: true, itName: "You"))
}
