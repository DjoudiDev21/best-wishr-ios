import SwiftUI

struct EventFilterChips: View {
    @Binding var selectedFilter: EventFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(EventFilter.allCases) { filter in
                    EventFilterChip(
                        filter: filter,
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct EventFilterChip: View {
    let filter: EventFilter
    let isSelected: Bool
    let onTap: () -> Void
    
    private var chipColor: Color {
        switch filter {
        case .all:
            return Color(red: 0.65, green: 0.3, blue: 0.8)
        case .upcoming:
            return Color(red: 0.2, green: 0.6, blue: 0.9)
        case .today:
            return Color(red: 1.0, green: 0.6, blue: 0.0)
        case .thisWeek:
            return Color(red: 0.6, green: 0.8, blue: 0.3)
        case .thisMonth:
            return Color(red: 0.9, green: 0.4, blue: 0.6)
        case .completed:
            return Color(red: 0.4, green: 0.8, blue: 0.4)
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: filter.icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .white : chipColor)
            
            Text(filter.rawValue)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .white : chipColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Group {
                if isSelected {
                    LinearGradient(
                        colors: [chipColor, chipColor.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    LinearGradient(
                        colors: [
                            chipColor.opacity(0.08),
                            chipColor.opacity(0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    isSelected ? Color.clear : chipColor.opacity(0.3),
                    lineWidth: 1
                )
        )
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        EventFilterChips(selectedFilter: .constant(.all))
        EventFilterChips(selectedFilter: .constant(.upcoming))
        EventFilterChips(selectedFilter: .constant(.today))
    }
    .padding()
}