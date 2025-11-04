# AWS デプロイガイド

## 📋 前提条件

- AWS アカウントを持っていること
- AWS CLI がインストール済み（[インストール方法](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)）
- AWS CLI が設定済み（`aws configure`実行済み）

## 🚀 クイックスタート（5分でデプロイ）

### ステップ1: AWS CLI設定

```bash
# AWS CLIの設定（初回のみ）
aws configure
```

以下を入力:
- AWS Access Key ID: [IAMユーザーのアクセスキー]
- AWS Secret Access Key: [IAMユーザーのシークレットキー]
- Default region name: ap-northeast-1
- Default output format: json

### ステップ2: デプロイ実行

```bash
# デプロイスクリプトに実行権限を付与
chmod +x aws-deploy.sh

# デプロイ実行
./aws-deploy.sh
```

### ステップ3: URL確認

デプロイ完了後、以下のURLが表示されます：

```
🌍 サイトURL:
http://presentation-contest-2025.s3-website-ap-northeast-1.amazonaws.com

📱 管理画面URL:
http://presentation-contest-2025.s3-website-ap-northeast-1.amazonaws.com/admin.html
```

## 🔒 HTTPS対応（CloudFront設定）

HTTPSを有効にする場合は、CloudFrontを設定します。

### 手動設定手順

1. **AWS Console にログイン**
   - https://console.aws.amazon.com/

2. **CloudFront を開く**
   - サービス検索で「CloudFront」を検索

3. **Create Distribution**
   - Origin domain: `presentation-contest-2025.s3-website-ap-northeast-1.amazonaws.com`
   - Origin path: 空欄
   - Name: `presentation-contest-2025-origin`

4. **Default cache behavior**
   - Viewer protocol policy: `Redirect HTTP to HTTPS`
   - Allowed HTTP methods: `GET, HEAD`
   - Cache policy: `CachingOptimized`

5. **Settings**
   - Price class: `Use only North America and Europe`（コスト削減）
   - Default root object: `login.html`

6. **Create distribution**をクリック

7. **ディストリビューションURLを確認**
   ```
   https://d123456789abcd.cloudfront.net
   ```

### CloudFront自動設定スクリプト

```bash
# CloudFront設定スクリプト
cat > setup-cloudfront.sh <<'EOF'
#!/bin/bash

BUCKET_NAME="presentation-contest-2025"
REGION="ap-northeast-1"

# CloudFrontディストリビューション作成
aws cloudfront create-distribution \
  --origin-domain-name "${BUCKET_NAME}.s3-website-${REGION}.amazonaws.com" \
  --default-root-object "login.html" \
  --query 'Distribution.DomainName' \
  --output text
EOF

chmod +x setup-cloudfront.sh
./setup-cloudfront.sh
```

## 📱 QRコード生成

### 1. QRコード生成ツールを開く

ブラウザで`qr-generator.html`を開く

### 2. URLを入力

取得したURLを入力:
- S3 URL（HTTP）
- CloudFront URL（HTTPS）※推奨
- カスタムドメイン（設定済みの場合）

### 3. QRコードを生成

「QRコードを生成」ボタンをクリック

### 4. ダウンロード

各QRコードの「画像をダウンロード」ボタンでPNG形式で保存

## 📊 生成されるQRコード

| QRコード | 用途 | URL例 |
|---------|------|-------|
| メインサイト | 一般参加者向け | `https://d123.cloudfront.net` |
| 管理画面 | 管理者専用 | `https://d123.cloudfront.net/admin.html` |
| プレゼン資料 | 資料ダウンロード | Google Drive等のリンク |

## 🔐 セキュリティ設定

### 管理者パスワード

現在設定されている管理者パスワード:
```
[REDACTED]
```

このパスワードは十分強固ですが、定期的な変更を推奨します。

### アクセスコード管理

1. 管理画面にアクセス
2. デフォルトコードを削除
3. 新しいコードを追加

推奨コード例:
- `CONTEST2025` - メイン参加者用
- `VIP2025NOV` - 特別ゲスト用
- `PRESS2025` - 報道関係者用

## 📈 コスト見積もり

### S3（月額）
- ストレージ: 約$0.01（10MB程度）
- データ転送: 約$0.10/GB
- リクエスト: 約$0.004/1000リクエスト

**月間見積もり: $1-5**（通常利用）

### CloudFront（月額）
- データ転送: 約$0.114/GB（日本）
- リクエスト: 約$0.0100/10,000リクエスト

**月間見積もり: $5-10**（HTTPS利用時）

### 合計見積もり
**月額: $6-15**（1000アクセス/月想定）

## 🛠️ トラブルシューティング

### エラー: Access Denied

```bash
# バケットポリシーを再設定
aws s3api put-bucket-public-access-block \
  --bucket presentation-contest-2025 \
  --public-access-block-configuration \
  "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

### エラー: 動画が再生されない

```bash
# 動画を個別にアップロード
aws s3 cp download.MP4 s3://presentation-contest-2025/download.MP4 \
  --content-type "video/mp4" \
  --cache-control "max-age=3600"
```

### CloudFrontが反映されない

```bash
# キャッシュ無効化
aws cloudfront create-invalidation \
  --distribution-id YOUR_DISTRIBUTION_ID \
  --paths "/*"
```

## 📝 更新手順

### ファイルの更新

```bash
# 特定ファイルの更新
aws s3 cp index.html s3://presentation-contest-2025/index.html \
  --cache-control "no-cache"

# 全ファイルの同期
aws s3 sync . s3://presentation-contest-2025 \
  --exclude "*.txt" \
  --exclude ".git/*" \
  --delete
```

### CloudFrontキャッシュクリア

```bash
# 全ファイルのキャッシュクリア
aws cloudfront create-invalidation \
  --distribution-id YOUR_DISTRIBUTION_ID \
  --paths "/*"
```

## 📊 アクセス分析

### CloudWatchでモニタリング

1. AWS Console → CloudWatch
2. Metrics → S3 → Bucket Metrics
3. `presentation-contest-2025`を選択

確認できる指標:
- NumberOfObjects（オブジェクト数）
- BucketSizeBytes（使用容量）
- AllRequests（リクエスト数）

### アクセスログ設定

```bash
# ログ用バケット作成
aws s3 mb s3://presentation-contest-2025-logs

# ログ記録を有効化
aws s3api put-bucket-logging \
  --bucket presentation-contest-2025 \
  --bucket-logging-status file://logging.json
```

## 🎯 チェックリスト

### デプロイ前
- [ ] Supabaseテーブル作成完了
- [ ] 管理者パスワード変更済み
- [ ] アクセスコード設定済み
- [ ] 動画ファイル準備完了

### デプロイ後
- [ ] サイトアクセス確認
- [ ] 管理画面アクセス確認
- [ ] QRコード生成完了
- [ ] CloudFront設定（HTTPS）
- [ ] アクセスコードでログイン確認

### 公開前
- [ ] 全ページ動作確認
- [ ] モバイル表示確認
- [ ] 動画再生確認
- [ ] 管理画面でコード追加テスト

## 📞 サポート

問題が発生した場合:

1. このガイドのトラブルシューティングを確認
2. AWS CloudWatchでエラーログ確認
3. Supabaseダッシュボードでデータベース状態確認

---

**注意**: 本番公開前に必ずすべての動作確認を行ってください。