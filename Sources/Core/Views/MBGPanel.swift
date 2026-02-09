public struct MBGPanel<Content: View>: View {

    /// タイトルの有無と切り欠き幅
    public enum Title {
        case none
        case text(String, gapWidth: CGFloat = 120)
    }

    /// サイズ指定
    public enum Size {
        case auto                  // コンテンツに合わせる
        case fixed(CGSize)         // 明示的に幅・高さを指定
    }

    let title: Title
    let borderStyle: PanelBorderStyle
    let size: Size
    let backgroundColor: Color
    let content: () -> Content

    public init(
        title: Title = .none,
        borderStyle: PanelBorderStyle = .standard,
        size: Size = .auto,
        backgroundColor: Color = .platformBackground,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.borderStyle = borderStyle
        self.size = size
        self.backgroundColor = backgroundColor
        self.content = content
    }

    public var body: some View {
        let cornerRadius: CGFloat = 16   // とりあえず固定（必要なら引数に）

        // 1) どの Shape を使うか
        let panelShape: some InsettableShape = {
            switch title {
            case .none:
                return RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            case .text(_, let gapWidth):
                return TitleGapPanel(cornerRadius: cornerRadius, gapWidth: gapWidth)
            }
        }()

        // 2) 中身＋タイトルを ZStack で重ねる
        var base = ZStack(alignment: .top) {
            panelShape
                .fill(backgroundColor)
                .panelBorder(borderStyle)

            // タイトルラベル（切り欠きがあるときだけ）
            if case let .text(label, _) = title {
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.systemBackground)
                    .offset(y: -10)
            }

            // コンテンツ本体
            VStack {
                Spacer(minLength: 16)
                content()
                    .padding(16)
                Spacer(minLength: 16)
            }
        }

        // 3) サイズ指定（auto / fixed）
        switch size {
        case .auto:
            base = base
                .fixedSize(horizontal: false, vertical: false)
        case .fixed(let s):
            base = base
                .frame(width: s.width, height: s.height)
        }

        return base
    }
}