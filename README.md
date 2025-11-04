# 高校生プレゼンテーションコンテスト2025 特設サイト

## プロジェクト概要

植草学園大学 高校生プレゼンテーションコンテスト2025の特設サイトです。

**テーマ**: 「五感でつながる子どもたち――高校生のまなざしから未来へ」

雲雀丘学園高等学校 地域共生ゼミによる、地域の子どもたちの格差解消と共感力あふれる社会づくりの提案を紹介しています。

## サイト構成

```
/
├── login.html          # ログインページ（Supabase認証）
├── index.html          # メインサイト
├── presenters.html     # 登壇者紹介ページ
├── admin.html          # 管理画面（アクセスコード管理）
├── download.MP4        # オープニング動画
├── supabase_setup.sql  # Supabaseテーブル作成SQL
├── SUPABASE_SETUP.md   # Supabaseセットアップガイド
└── *.txt              # プレゼン資料・台本
```

## 主な機能

### 1. アクセス制限
- **Supabase認証システム実装済み**
- データベースでアクセスコードを管理
- 有効期限設定可能
- アクセスログ自動記録
- セッションストレージによる24時間の認証維持
- 管理画面でコードの追加・編集・削除が可能

### 2. オープニング動画
- 15秒の自動再生動画
- ミュート/ミュート解除機能
- スキップボタン
- 動画ファイルが存在しない場合のフォールバック

### 3. メインコンテンツ
- **ヒーローセクション**: 五感のビジュアル表現
- **問題提起**: データビジュアライゼーション（Chart.js使用）
- **ソリューション**: 農業体験プログラムの詳細
- **インパクト**: 3つの期待される効果
- **高校生の思い**: 現役高校生の本音（全文掲載）
- **CTA**: QRコード、SNSシェア、問い合わせ

### 4. アニメーション
- GSAP（GreenSock Animation Platform）による滑らかなアニメーション
- スクロールトリガーアニメーション
- カウントアップ効果
- パララックス効果

### 5. レスポンシブデザイン
- モバイルファースト設計
- タブレット、デスクトップ対応
- タッチジェスチャー対応

## セットアップ手順

### 1. Supabase設定（必須）

#### 1.1 テーブルの作成
1. [Supabase Dashboard](https://app.supabase.com)にログイン
2. SQL Editorを開く
3. `supabase_setup.sql`の内容を実行
4. 初期データが登録されることを確認

#### 1.2 接続情報の更新（既に設定済み）
`login.html`と`admin.html`に以下が設定されています:

```javascript
const SUPABASE_URL = 'https://goneyrlzzblcyzasecnl.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJI...';
```

### 2. 管理者パスワードの変更

`admin.html`の以下の部分を編集:

```javascript
const ADMIN_PASSWORD = 'admin2025'; // ← 強固なパスワードに変更
```

### 3. アクセスコードの設定

1. ブラウザで`admin.html`を開く
2. 管理者パスワードでログイン
3. 「新規コード追加」でアクセスコードを追加
4. 不要なコードは削除または無効化

### 4. ファイルのアップロード

```bash
# すべてのファイルをサーバーにアップロード
# 特別な依存関係はありません（CDN使用）
```

### 5. 動画の差し替え

オープニング動画を差し替える場合:

1. 新しい動画ファイルを`download.MP4`として保存
2. または`index.html`の以下の部分を編集:

```html
<video id="openingVideo" class="w-full h-full object-cover" muted autoplay>
    <source src="./your-video.mp4" type="video/mp4">
</video>
```

## AWS デプロイ手順

### 1. S3バケットの作成

```bash
# AWS CLIを使用する場合
aws s3 mb s3://presentation-contest-2025

# 静的ウェブホスティングを有効化
aws s3 website s3://presentation-contest-2025 \
  --index-document login.html \
  --error-document error.html
```

### 2. ファイルのアップロード

```bash
# すべてのファイルをアップロード
aws s3 sync . s3://presentation-contest-2025 \
  --exclude ".git/*" \
  --exclude "*.txt:Zone.Identifier"
```

### 3. バケットポリシーの設定

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::presentation-contest-2025/*"
    }
  ]
}
```

### 4. CloudFront（CDN）の設定（推奨）

1. CloudFrontディストリビューションを作成
2. オリジンにS3バケットを指定
3. デフォルトルートオブジェクトに`login.html`を設定
4. HTTPSを有効化

### 5. Route 53でのドメイン設定（オプション）

カスタムドメインを使用する場合:

1. Route 53でホストゾーンを作成
2. CloudFrontディストリビューションにAレコードを設定
3. SSL証明書をACM（AWS Certificate Manager）で取得

## カスタマイズ

### カラーテーマの変更

`index.html`と`presenters.html`の以下の部分を編集:

```css
:root {
    --warm-orange: #FF6B35;   /* 暖かいオレンジ */
    --natural-green: #8BC34A; /* 自然な緑 */
    --earth-brown: #795548;   /* 土の茶色 */
}
```

### Google Forms埋め込み

問い合わせフォームにGoogle Formsを埋め込む場合:

```html
<!-- index.html内の該当箇所 -->
<div class="bg-gray-100 h-64 rounded-lg flex items-center justify-center mb-6">
    <iframe src="YOUR_GOOGLE_FORMS_URL"
            width="100%"
            height="100%"
            frameborder="0">
    </iframe>
</div>
```

### QRコードの生成

プレゼン資料へのQRコードを生成して配置:

```html
<!-- index.html内の該当箇所 -->
<div class="bg-gray-200 w-48 h-48 mx-auto mb-4">
    <img src="qr-code.png" alt="QRコード" class="w-full h-full">
</div>
```

## トラブルシューティング

### 動画が再生されない
- ファイル形式がMP4であることを確認
- ブラウザのコンソールでエラーを確認
- フォールバックアニメーションが表示されることを確認

### アニメーションが動かない
- JavaScriptコンソールでエラーを確認
- CDNへの接続を確認
- ブラウザのJavaScriptが有効になっていることを確認

### 認証が機能しない
- セッションストレージが有効になっていることを確認
- プライベートブラウジングモードでないことを確認
- アクセスコードが正しいことを確認

## ブラウザ対応

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+
- モバイルブラウザ（iOS Safari, Chrome Mobile）

## 使用技術

- **HTML5/CSS3**: 構造とスタイリング
- **Tailwind CSS**: ユーティリティファーストCSSフレームワーク
- **JavaScript (ES6+)**: インタラクティブ機能
- **GSAP**: アニメーションライブラリ
- **Chart.js**: データビジュアライゼーション
- **Font Awesome**: アイコン
- **Google Fonts**: 日本語Webフォント（Noto Sans JP）

## ライセンス

© 2025 雲雀丘学園高等学校. All rights reserved.

## お問い合わせ

雲雀丘学園高等学校 地域共生ゼミ
〒665-0805 兵庫県宝塚市雲雀丘4-2-1

---

**注意事項**:
- 本サイトは関係者限定公開を想定しています
- アクセスコードは定期的に変更することを推奨します
- 個人情報を含む場合は適切なセキュリティ対策を実施してください