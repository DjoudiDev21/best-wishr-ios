import SwiftUI

struct SavedGiftsHeader: View {
    let stats: GiftStats
    @Binding var selectedTab: SavedGiftsScreen.SavedGiftsTab
    
    var body: some View {
        VStack(spacing: 16) {
            SavedGiftsStats(stats: stats)
            
            SavedGiftsTabPicker(selectedTab: $selectedTab)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

struct SavedGiftsStats: View {
    let stats: GiftStats
    
    var body: some View {
        HStack(spacing: 12) {
            SavedGiftsStatCard(
                icon: "heart",
                title: "Saved",
                value: "\(stats.totalWishlisted)",
                color: Color.red
            )
            
            SavedGiftsStatCard(
                icon: "checkmark.circle",
                title: "Purchased",
                value: "\(stats.totalPurchased)",
                color: Color.green
            )
            
            SavedGiftsStatCard(
                icon: "dollarsign.circle",
                title: "Total Value",
                value: formatCurrency(stats.totalValue),
                color: Color(red: 0.65, green: 0.3, blue: 0.8)
            )
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

struct SavedGiftsStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct SavedGiftsTabPicker: View {
    @Binding var selectedTab: SavedGiftsScreen.SavedGiftsTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(SavedGiftsScreen.SavedGiftsTab.allCases, id: \.self) { tab in
                SavedGiftsTabButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct SavedGiftsTabButton: View {
    let tab: SavedGiftsScreen.SavedGiftsTab
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(tab.rawValue)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .white : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    Group {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.65, green: 0.3, blue: 0.8))
                        }
                    }
                )
        }
    }
}

#Preview {
    SavedGiftsHeader(
        stats: GiftStats(
            totalWishlisted: 12,
            totalPurchased: 5,
            totalValue: 850.50,
            mostPopularCategory: .electronics
        ),
        selectedTab: .constant(.saved)
    )
    .padding()
}