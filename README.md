# SwiftUIだけで描画したリアルなスイッチ作りたい
- 画像使うと色々面倒なので、CSSでおしゃれボタン作るみたいに作ってみました。
- SwiftUIはコンポーネントでまとめられるのでいいですね。

# 作ったスイッチ

1. ON状態。光ってます。
    <img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2918864/824b81ca-3670-2866-0979-480ee003614d.png" width=300>

1. OFF状態。iPhoneで「ククッ」みたいに触覚フィードバックあるとそれっぽくなります。
    <img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2918864/8718b2cf-3499-1566-b474-e58723dad0f8.png" width=300>

# GitHub
https://github.com/honokiyuto/RealSwitch

# ソースコード
1. まずContentView。普通に`@State`でBool値を持たせる。見た目自体は後述の構造体で`SwitchButtonView(isOn: isOn)`でデザインされており、ボタンのラベル扱いにする。

    ```swift: ContentView.swift
    struct ContentView: View {
    
        @State var isOn: Bool = true
        
        var body: some View {
            Button {
                isOn.toggle()
                // ここに触覚FBのモジュールとか入れるといい。
            } label: {
                SwitchButtonView(isOn: isOn)
            }
            .buttonStyle(.plain)
        }
    }
    ```
1. 続いて、上記で出た`SwitchButtonView(isOn: isOn)`。ここでは、スイッチの土台と、側面と、スイッチの部分と３つを`ZStack`で重ねている。`isOn`が`ture`と`false`に切り替わることで、スイッチの表面部分が上下(y方向)に`offset`する。

    ```swift:SwitchButtonView
    struct SwitchButtonView: View {
        
        let isOn: Bool
        @State var yOffset: CGFloat = 0
        
        var body: some View {
            ZStack {
                //　スイッチの土台
                SwitchFoundationView()
                // スイッチの側面
                SwitchSideView()
                // スイッチの表面
                SwitchToggleView(isOn: isOn)
                    .offset(y: isOn ? -6 : 6)
            }
        }
    }
    ```


1. 続いて色を定義している構造体。グラデーションなども多様している。もっといいやり方ある気がする（本来はAssetにカラーを登録するべきなんだろう・・・）。

    ```swift:SwitchBaseColor
    struct SwitchBaseColor {
        // 加工したカラー
        let baseColor: Color
        let blackColor: Color
        let darkColor: Color
        let lightColor: Color
        // スイッチのカラー
        let colorSideTop: LinearGradient
        let colorSideBottom: Color
        let colorLighting: Color
        let colorOn: LinearGradient
        let colorOff: LinearGradient
        let colorSwitchEdge: Color
        // スイッチの土台のカラー
        let colorBase : LinearGradient
        let colorFoundationEdge: Color
        
        init () {
            baseColor = Color(red: 1.0, green: 0.0, blue: 0.0)
            blackColor = Color(red: 0.5, green: 0.0, blue: 0.0)
            darkColor = Color(red: 0.7, green: 0.0, blue: 0.0)
            lightColor = Color(red: 1.0, green: 0.5, blue: 0.5)
            colorSideTop = LinearGradient(
                gradient: Gradient(colors: [darkColor, lightColor, darkColor]),
                startPoint: .leading, endPoint: .trailing
            )
            colorSideBottom = blackColor
            colorLighting = lightColor
            colorOn = LinearGradient(
                gradient: Gradient(colors: [lightColor, darkColor]),
                startPoint: .top, endPoint: .bottomTrailing
            )
            colorOff = LinearGradient(
                gradient: Gradient(colors: [blackColor, baseColor]),
                startPoint: .top, endPoint: .bottomTrailing
            )
            colorBase = LinearGradient(
                gradient: Gradient(colors: [Color(UIColor.darkGray), .black]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            colorSwitchEdge = Color.white
            colorFoundationEdge = Color.secondary
        }
    }
    ```

1. 残りは、スイッチの土台と、スイッチの側面と、スイッチの表面の３つを定義している構造体たちです。時間ある時にゆっくりみてください。色は、上記の`SwitchBaseColor`をインスタンス化して持ってきてます（絶対もっといいやり方ある）。

    - `SwitchToggleView`：スイッチの表面
    - `SwitchSideView`： スイッチの側面
    - `SwitchFoundationView`： スイッチの土台

    ```swift: その他
    // スイッチの表面
    struct SwitchToggleView: View{
        
        let isOn: Bool
        
        private let baseColor = SwitchBaseColor()
        
        private let width: CGFloat = 70
        private let height: CGFloat = 140
        private let cornerRadius: CGFloat = 10
        
        var body: some View {
            ZStack {
                if isOn {
                    Circle()  // ボタンの明かり
                        .fill(baseColor.colorLighting)
                        .frame(width: 100, height: 100)
                        .offset(x: 0, y: -height / 2.5)
                        .blur(radius: 30)
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(baseColor.colorSwitchEdge)
                            .offset(x: 0, y: 1)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(baseColor.colorOn)
                        VStack {
                            Text("ON")
                                .fontWeight(.heavy)
                                .padding()
                                .foregroundColor(baseColor.colorSwitchEdge)
                                .shadow(color: baseColor.colorSwitchEdge, radius: 8, x: 0, y: 0)
                            Spacer()
                            Text("OFF")
                                .fontWeight(.heavy)
                                .padding()
                                .foregroundColor(baseColor.blackColor)
                        }
                    }
                    .frame(width: width, height: height)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.white)
                            .offset(x: 0, y: -1)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(baseColor.colorOff)
                        VStack {
                            Text("ON")
                                .padding()
                                .fontWeight(.heavy)
                                .foregroundColor(baseColor.blackColor)
                            Spacer()
                            Text("OFF")
                                .padding()
                                .fontWeight(.heavy)
                                .foregroundColor(baseColor.blackColor)
                        }
                    }
                    .frame(width: width, height: height)
                }
            }
        }
    }
    
    // スイッチの側面
    struct SwitchSideView: View{
        
        private let width: CGFloat = 70
        private let height: CGFloat = 150
        private let cornerRadius: CGFloat = 10
        private let baseColor = SwitchBaseColor()
        
        var body: some View {
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(baseColor.colorSideTop)
                    .frame(width: width, height: height / 2)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(baseColor.colorSideBottom)
                    .frame(width: width, height: height / 2)
            }
        }
    }
    
    // スイッチの土台
    struct SwitchFoundationView: View{
        
        private let width: CGFloat = 120
        private let height: CGFloat = 200
        private let cornerRadius: CGFloat = 10
        
        private let baseColor = SwitchBaseColor()
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(baseColor.colorFoundationEdge)
                    .frame(width: width + 2, height: height + 2)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(baseColor.colorBase)
                    .frame(width:width, height: height)
            }
        }
    }
    ```

1. 以上です。



# 参考

https://jajaaan.co.jp/css/button/


- 上記WebページのCSSで作った「スイッチ赤 ON OFF」というやつをSwiftUIで模写しました。
