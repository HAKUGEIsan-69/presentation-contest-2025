# 🚀 クイックスタートガイド

高校生プレゼンテーションコンテスト2025 特設サイトを**15分で公開**する手順です。

## 📝 事前準備チェックリスト

- [ ] AWSアカウントを持っている
- [ ] Supabaseアカウントを持っている
- [ ] 管理者パスワードは変更済み（Supabaseで設定）

## 🎯 3ステップで公開

### ステップ1️⃣: Supabase設定（5分）

1. [Supabaseダッシュボード](https://app.supabase.com/project/goneyrlzzblcyzasecnl/sql/new)を開く
2. SQL Editorに`supabase_setup.sql`の内容をコピペ
3. 「Run」ボタンをクリック
4. ✅ テーブル作成完了！

### ステップ2️⃣: AWS公開（5分）

#### オプションA: コマンドライン（推奨）

```bash
# AWS CLIインストール済みの場合
chmod +x aws-deploy.sh
./aws-deploy.sh
```

#### オプションB: AWS Consoleで手動

1. [AWS S3](https://s3.console.aws.amazon.com/)にログイン
2. 「Create bucket」→ 名前: `presentation-contest-2025`
3. 「Properties」→「Static website hosting」→ Enable
4. 「Permissions」→「Block public access」→ すべてOFF
5. ファイルをアップロード

### ステップ3️⃣: QRコード生成（5分）

1. ブラウザで`qr-generator.html`を開く
2. 取得したURLを入力:
   ```
   http://presentation-contest-2025.s3-website-ap-northeast-1.amazonaws.com
   ```
3. 「QRコードを生成」クリック
4. 画像をダウンロード

## ✅ 完了！

### 🔗 アクセスURL

| ページ | URL |
|-------|-----|
| **ログイン画面** | `http://[your-bucket].s3-website-ap-northeast-1.amazonaws.com` |
| **管理画面** | `http://[your-bucket].s3-website-ap-northeast-1.amazonaws.com/admin.html` |
| **メインサイト** | ログイン後自動遷移 |

### 🔐 ログイン情報

| 項目 | 値 |
|-----|-----|
| **管理者パスワード** | Supabaseで設定 |
| **初期アクセスコード** | `UEKUSA2025` / `GUEST2025` |

## 📱 QRコード配置例

### プレゼンスライド用
```
┌─────────────┐
│             │  高校生プレゼンテーションコンテスト2025
│  QRコード   │  特設サイトはこちら
│             │
└─────────────┘  アクセスコード: [別途配布]
```

### 配布資料用
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🌐 特設サイト          📱 管理画面（関係者限定）

 [QRコード]            [QRコード]

 どなたでも            管理者専用
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🆘 よくある質問

### Q: ログインできない
**A:** Supabaseでテーブルが作成されているか確認してください。

### Q: 動画が再生されない
**A:** `download.MP4`ファイルが正しくアップロードされているか確認。

### Q: QRコードが読み取れない
**A:** HTTPSが必要な場合はCloudFrontを設定してください（詳細は`AWS_DEPLOY_GUIDE.md`参照）。

### Q: アクセスコードを変更したい
**A:** 管理画面（`/admin.html`）から変更できます。

## 📊 公開前チェックリスト

### 必須確認
- [ ] Supabaseでテーブル作成済み
- [ ] AWSにファイルアップロード済み
- [ ] ログインページが表示される
- [ ] アクセスコードでログインできる
- [ ] 管理画面にアクセスできる

### 推奨確認
- [ ] CloudFront設定（HTTPS化）
- [ ] カスタムアクセスコード設定
- [ ] QRコード生成・印刷
- [ ] モバイル表示確認
- [ ] 動画再生確認

## 🎉 公開準備完了！

これで高校生プレゼンテーションコンテスト2025の特設サイトが公開されました。

### 次のアクション

1. **アクセスコードを配布**
   - 参加者にメールで送信
   - 当日配布資料に記載

2. **QRコードを設置**
   - プレゼンスライドに埋め込み
   - 会場に掲示

3. **アクセス状況を確認**
   - 管理画面でログを確認
   - 必要に応じてコード追加

## 📞 サポート

問題が発生した場合は以下のドキュメントを参照:
- `README.md` - 詳細な機能説明
- `SUPABASE_SETUP.md` - データベース設定
- `AWS_DEPLOY_GUIDE.md` - AWS詳細設定

---

**Good luck with your presentation! 🌟**

雲雀丘学園高等学校 地域共生ゼミ