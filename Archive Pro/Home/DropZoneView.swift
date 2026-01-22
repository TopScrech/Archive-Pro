import ScrechKit

struct DropZoneView: View {
    let isTargeted: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.white.opacity(isTargeted ? 0.24 : 0.12))
                    .frame(96)
                
                Image(systemName: isTargeted ? "arrow.down.doc.fill" : "tray.and.arrow.down.fill")
                    .fontSize(34)
                    .semibold()
                    .symbolRenderingMode(.hierarchical)
            }
            
            Text(isTargeted ? "Release to process" : "Drag and drop files or folders")
                .title()
            
            Text(isTargeted ? "We will archive or extract automatically" : "Zip, tar, 7z, rar, Apple Archive, XAR, and more")
                .secondary()
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial, in: .rect(cornerRadius: 28))
        .background {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.18, green: 0.32, blue: 0.45),
                        Color(red: 0.16, green: 0.45, blue: 0.38)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(isTargeted ? 0.6 : 0.35)
                
                Circle()
                    .fill(.white.opacity(isTargeted ? 0.18 : 0.1))
                    .frame(220)
                    .offset(x: 140, y: -160)
                
                RoundedRectangle(cornerRadius: 56)
                    .fill(.white.opacity(isTargeted ? 0.16 : 0.08))
                    .frame(width: 260, height: 140)
                    .rotationEffect(.degrees(-12))
                    .offset(x: -120, y: 140)
            }
            .clipShape(.rect(cornerRadius: 28))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(
                    isTargeted ? .white.opacity(0.6) : .white.opacity(0.35),
                    style: StrokeStyle(lineWidth: 2, dash: [8, 6])
                )
        }
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        .animation(.easeInOut(duration: 0.2), value: isTargeted)
    }
}
