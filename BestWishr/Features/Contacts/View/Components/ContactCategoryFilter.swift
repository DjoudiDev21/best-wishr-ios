import SwiftUI

struct ContactCategoryFilter: View {
    @Binding var selectedCategory: ContactCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All filter
                FilterChip(
                    title: "All",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                // Category filters
                ForEach(ContactCategory.allCases) { category in
                    FilterChip(
                        title: category.rawValue,
                        icon: category.icon,
                        color: category.color,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct FilterChip: View {
    let title: String
    let icon: String?
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void
    
    init(
        title: String,
        icon: String? = nil,
        color: Color = Color(red: 0.65, green: 0.3, blue: 0.8),
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    var body: some View {
        HStack(spacing: 6) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : color)
            }
            
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .white : color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Group {
                if isSelected {
                    LinearGradient(
                        colors: [color, color.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    LinearGradient(
                        colors: [
                            color.opacity(0.08),
                            color.opacity(0.03)
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
                    isSelected ? Color.clear : color.opacity(0.3),
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
        ContactCategoryFilter(selectedCategory: .constant(nil))
        ContactCategoryFilter(selectedCategory: .constant(.friends))
        ContactCategoryFilter(selectedCategory: .constant(.family))
    }
    .padding()
}