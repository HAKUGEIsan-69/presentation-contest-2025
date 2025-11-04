# GitHub経由での公開ガイド

## 📝 公開方法の選択肢

GitHubにアップロード後、以下の方法で公開できます：

| 方法 | 料金 | HTTPS | カスタムドメイン | 難易度 |
|-----|------|-------|----------------|--------|
| **GitHub Pages** | 無料 | ✅ | ✅ | ⭐ 簡単 |
| **Vercel** | 無料 | ✅ | ✅ | ⭐ 簡単 |
| **Netlify** | 無料 | ✅ | ✅ | ⭐ 簡単 |
| **AWS S3 + CloudFront** | 有料 | ✅ | ✅ | ⭐⭐ 普通 |

## 🚀 ステップ1: GitHubへアップロード

### 1.1 GitHubリポジトリの作成

1. [GitHub](https://github.com/new)にアクセス
2. リポジトリ名: `presentation-contest-2025`
3. Public/Privateを選択（GitHub Pagesを使う場合はPublic推奨）
4. 「Create repository」をクリック

### 1.2 ローカルでGit初期化とアップロード

```bash
# 現在のフォルダで実行
cd /home/hakugeisan/Products/Presentation_contest_2025_uekusa

# Git初期化
git init

# すべてのファイルを追加
git add .

# 初回コミット
git commit -m "Initial commit: 高校生プレゼンテーションコンテスト2025 特設サイト"

# GitHubリポジトリと連携（YOUR_USERNAMEを置き換え）
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/presentation-contest-2025.git

# プッシュ
git push -u origin main
```

## 📱 オプションA: GitHub Pages で公開（推奨・無料）

### 設定手順

1. GitHubリポジトリページを開く
2. Settings → Pages
3. Source: Deploy from a branch
4. Branch: main / root
5. Save

### 公開URLの変更

GitHub Pagesはindex.htmlをトップページとするため、以下の変更が必要です：

#### 方法1: index.htmlをlogin.htmlに変更

```bash
# ファイル名を変更
mv index.html main.html
mv login.html index.html

# main.htmlへのリダイレクトを修正
sed -i 's/index.html/main.html/g' index.html
sed -i 's/index.html/main.html/g' admin.html
sed -i 's/index.html/main.html/g' presenters.html

# 変更をコミット
git add .
git commit -m "GitHub Pages用にファイル名を調整"
git push
```

#### 方法2: リダイレクトを設定

`index.html`を作成してリダイレクト：

```html
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="refresh" content="0; url=login.html">
</head>
<body>
    <script>window.location.href = "login.html";</script>
</body>
</html>
```

### アクセスURL

```
https://YOUR_USERNAME.github.io/presentation-contest-2025/
```

## ⚡ オプションB: Vercel で公開（推奨・無料）

### 設定手順

1. [Vercel](https://vercel.com)にアクセス
2. GitHubでログイン
3. 「Import Project」→ GitHubリポジトリを選択
4. Framework Preset: Other
5. 「Deploy」をクリック

### カスタム設定（vercel.json）

```json
{
  "rewrites": [
    { "source": "/", "destination": "/login.html" }
  ]
}
```

### アクセスURL

```
https://presentation-contest-2025-YOUR_USERNAME.vercel.app/
```

## 🌐 オプションC: Netlify で公開（無料）

### 設定手順

1. [Netlify](https://app.netlify.com)にアクセス
2. GitHubでログイン
3. 「New site from Git」→ リポジトリを選択
4. Build settings: そのまま
5. 「Deploy site」をクリック

### カスタム設定（_redirects）

```
/ /login.html 200
```

### アクセスURL

```
https://YOUR_SITE_NAME.netlify.app/
```

## ☁️ オプションD: AWS S3 で公開（有料）

GitHubにアップロード後、GitHub Actionsで自動デプロイ：

### .github/workflows/deploy.yml

```yaml
name: Deploy to S3

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ap-northeast-1

    - name: Sync to S3
      run: |
        aws s3 sync . s3://presentation-contest-2025 \
          --exclude ".git/*" \
          --exclude ".github/*" \
          --delete
```

## 📊 各方法の比較

### GitHub Pages
✅ **メリット**
- 完全無料
- GitHub統合
- 自動HTTPS
- カスタムドメイン対応

❌ **デメリット**
- Publicリポジトリ必須（無料プランの場合）
- 静的サイトのみ

### Vercel
✅ **メリット**
- 完全無料
- 自動HTTPS
- 高速CDN
- プレビューデプロイ

❌ **デメリット**
- 月間帯域制限（100GB）

### Netlify
✅ **メリット**
- 完全無料
- 自動HTTPS
- フォーム機能
- 関数機能

❌ **デメリット**
- 月間帯域制限（100GB）

### AWS S3
✅ **メリット**
- 完全なコントロール
- 無制限のスケール
- CloudFront統合

❌ **デメリット**
- 有料（月$5-15）
- 設定が複雑

## 🎯 推奨構成

**プレゼンテーションコンテスト用途の場合：**

### 1. GitHub Pages（最も簡単）
```
費用: 無料
設定時間: 5分
URL: https://username.github.io/presentation-contest-2025/
```

### 2. Vercel（最も高速）
```
費用: 無料
設定時間: 3分
URL: https://presentation-contest-2025.vercel.app/
```

## 📱 QRコード生成

公開後、`qr-generator.html`を使用：

1. ブラウザで`qr-generator.html`を開く
2. 公開URLを入力
3. QRコードを生成・ダウンロード

## ✅ チェックリスト

### GitHubアップロード前
- [x] Supabase設定完了
- [ ] .gitignoreファイル作成
- [ ] README.md確認
- [ ] 管理者パスワード変更済み

### GitHubアップロード後
- [ ] リポジトリ作成
- [ ] ファイルプッシュ
- [ ] 公開方法選択（Pages/Vercel/Netlify/AWS）
- [ ] 公開URL確認

### 公開後
- [ ] ログインテスト
- [ ] 管理画面アクセス
- [ ] QRコード生成
- [ ] 関係者に共有

## 🆘 トラブルシューティング

### GitHub Pagesが表示されない
- Settings → Pages で設定確認
- 5-10分待つ（初回は時間がかかる）
- https://YOUR_USERNAME.github.io/presentation-contest-2025/

### Vercel/Netlifyでエラー
- Build settingsを確認
- Framework: なし/Other を選択

### ログインできない
- Supabase URLとAPIキーを確認
- ブラウザのコンソールでエラー確認

## 📞 サポート

問題が発生した場合：
1. GitHubのIssuesで報告
2. 各サービスのドキュメント参照
3. コミュニティフォーラムで質問

---

**Good luck! 🎉**