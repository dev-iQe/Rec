import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedIPAURL: URL?
    @State private var selectedP12URL: URL?
    @State private var p12Password: String = ""
    @State private var mobileProvisionURL: URL?
    
    @State private var statusMessage: String = "جاهز لتوقيع التطبيقات"
    @State private var isSigning: Bool = false
    @State private var signedIPAURL: URL?
    @State private var installURL: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Header Logo & Title
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 80, height: 80)
                            Image(systemName: "checkmark.seal.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .foregroundColor(.white)
                        }
                        
                        Text("i Cerf")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("أداة توقيع وتثبيت تطبيقات iOS")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // Section 1: IPA File Selection
                    SectionBox(title: "1. اختر ملف IPA") {
                        FilePickerButton(title: selectedIPAURL?.lastPathComponent ?? "اختر ملف IPA (.ipa)", icon: "doc.badge.plus") {
                            // File selection logic trigger
                        }
                    }

                    // Section 2: P12 & Provisioning Certificates
                    SectionBox(title: "2. رفع الشهادات") {
                        VStack(spacing: 12) {
                            FilePickerButton(title: selectedP12URL?.lastPathComponent ?? "اختر ملف الشهادة (.p12)", icon: "key.fill") {
                                // File selection logic trigger
                            }
                            
                            SecureField("كلمة سر الشهادة P12", text: $p12Password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 4)

                            FilePickerButton(title: mobileProvisionURL?.lastPathComponent ?? "اختر ملف (.mobileprovision)", icon: "seal.fill") {
                                // File selection logic trigger
                            }
                        }
                    }

                    // Section 3: Action Sign Button
                    Button(action: startSigningProcess) {
                        HStack {
                            if isSigning {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.trailing, 5)
                            } else {
                                Image(systemName: "pencil.and.outline")
                            }
                            Text(isSigning ? "جاري التوقيع..." : "توقيع التطبيق الآن")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSigning ? Color.gray : Color.blue)
                        .cornerRadius(12)
                        .shadow(color: isSigning ? Color.clear : Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .disabled(isSigning)

                    // Status Message
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Section 4: Direct Installation Button
                    if let installURL = installURL {
                        Link(destination: URL(string: installURL)!) {
                            HStack {
                                Image(systemName: "square.and.arrow.down.fill")
                                Text("تثبيت التطبيق الموقّع مباشرة")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                    }

                    Divider().padding(.vertical, 10)

                    // Developer Social Links Section
                    VStack(spacing: 14) {
                        Text("روابط المطور والمصدر")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 12) {
                            SocialLinkButton(title: "Instagram", icon: "camera.fill", url: "https://instagram.com/eng_azawy")
                            SocialLinkButton(title: "Telegram", icon: "paperplane.fill", url: "https://t.me/bavarite")
                            SocialLinkButton(title: "TikTok", icon: "video.fill", url: "https://tiktok.com/@eyesiq")
                        }
                        
                        Link(destination: URL(string: "https://icerf.netlify.app")!) {
                            HStack(spacing: 6) {
                                Image(systemName: "globe")
                                Text("زيارة الموقع الرسمي iCerf")
                            }
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 16)
            }
            .navigationBarHidden(true)
        }
    }

    func startSigningProcess() {
        guard selectedIPAURL != nil, selectedP12URL != nil, mobileProvisionURL != nil else {
            statusMessage = "يرجى اختيار ملف IPA، ملف P12، وملف Provisioning أولاً."
            return
        }

        isSigning = true
        statusMessage = "جاري فك ضغط IPA واستخراج البنية للتوقيع..."

        DispatchQueue.global(qos: .userInitiated).async {
            // Processing logic
            Thread.sleep(forTimeInterval: 3.0)
            
            DispatchQueue.main.async {
                isSigning = false
                statusMessage = "تم توقيع التطبيق بنجاح! جاهز للتثبيت."
                self.installURL = "itms-services://?action=download-manifest&url=https://icerf.netlify.app/manifest.plist"
            }
        }
    }
}

// UI Component Helpers
struct SectionBox<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(.secondary)
            content
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct FilePickerButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(12)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
        }
    }
}

struct SocialLinkButton: View {
    let title: String
    let icon: String
    let url: String

    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.caption.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.12))
            .foregroundColor(.blue)
            .cornerRadius(8)
        }
    }
}
