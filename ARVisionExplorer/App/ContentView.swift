import SwiftUI
import RealityKit

struct ContentView: View {
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var avatarViewModel: AvatarViewModel
    @State private var showProfile = false
    @State private var showSettings = false

    var body: some View {
        ZStack {
            // MARK: - AR Camera (Full Screen Background)
            ARContainerView()
                .environmentObject(arViewModel)
                .ignoresSafeArea()

            // MARK: - Scanning Overlay Effects
            if arViewModel.isScanning {
                ScanningOverlayView()
                    .allowsHitTesting(false)
                    .transition(.opacity)
            }

            // MARK: - Main UI Overlay
            VStack(spacing: 0) {
                // Top Bar
                topBar
                    .padding(.top, 8)

                Spacer()

                // Avatar Speech Area
                if avatarViewModel.isVisible {
                    AvatarOverlayView()
                        .environmentObject(avatarViewModel)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .opacity
                        ))
                        .padding(.horizontal, 20)
                }

                Spacer()

                // Detected Object Info Card
                if let detectedObject = arViewModel.currentDetectedObject {
                    ObjectInfoCard(object: detectedObject)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        ))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                }

                // Exploded View Detail Panel
                if arViewModel.isExplodedViewActive {
                    ExplodedDetailPanel(
                        components: arViewModel.explodedComponents,
                        productName: arViewModel.currentDetectedObject?.name ?? ""
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }

                // Bottom Hint
                if !arViewModel.isExplodedViewActive && arViewModel.currentDetectedObject == nil {
                    bottomHint
                        .padding(.bottom, 24)
                }
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: arViewModel.isScanning)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: arViewModel.currentDetectedObject?.id)
        .animation(.spring(response: 0.6, dampingFraction: 0.75), value: arViewModel.isExplodedViewActive)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: avatarViewModel.isVisible)
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            // Profile Button
            Button(action: { showProfile = true }) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(width: 44, height: 44)
                    .glassBackground(cornerRadius: 22)
            }

            Spacer()

            // AI Status Indicator
            HStack(spacing: 8) {
                Circle()
                    .fill(arViewModel.isScanning ? Color.accentGlow : Color.white.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .shadow(color: arViewModel.isScanning ? Color.accentGlow.opacity(0.6) : .clear, radius: 4)

                Text(arViewModel.isScanning ? "AI يحلل البيئة..." : "جاهز للمسح")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .glassBackground(cornerRadius: 20)

            Spacer()

            // Settings Button
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(width: 44, height: 44)
                    .glassBackground(cornerRadius: 22)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Bottom Hint
    private var bottomHint: some View {
        VStack(spacing: 6) {
            Image(systemName: "camera.viewfinder")
                .font(.title2)
                .foregroundStyle(Color.accentGlow.opacity(0.7))

            Text("وجّه الكاميرا نحو أي جسم للتعرف عليه")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.5))

            Text("اضغط مطولاً لتفكيك الجسم")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.3))
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 16)
        .padding(.horizontal, 32)
        .glassBackground(cornerRadius: 16)
    }
}

// MARK: - Placeholder Views
struct ProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.trueBlack.ignoresSafeArea()
                Text("الملف الشخصي")
                    .foregroundStyle(.white)
            }
            .navigationTitle("الملف الشخصي")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.trueBlack.ignoresSafeArea()
                VStack(spacing: 20) {
                    settingsRow(icon: "cube.transparent", title: "جودة التفكيك", subtitle: "عالية")
                    settingsRow(icon: "person.fill", title: "الشخصية الرقمية", subtitle: "النمط الافتراضي")
                    settingsRow(icon: "speaker.wave.3.fill", title: "الصوت", subtitle: "مفعّل")
                    settingsRow(icon: "hand.tap.fill", title: "الاهتزاز التفاعلي", subtitle: "مفعّل")
                    settingsRow(icon: "globe", title: "اللغة", subtitle: "العربية")
                }
                .padding()
            }
            .navigationTitle("الإعدادات")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func settingsRow(icon: String, title: String, subtitle: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.accentGlow)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            Image(systemName: "chevron.left")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.3))
        }
        .padding()
        .glassBackground(cornerRadius: 12)
    }
}
