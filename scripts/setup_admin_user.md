# Supabase管理者ユーザー設定手順

## 方法1: Supabaseダッシュボードから作成（推奨）

1. [Supabase Dashboard](https://app.supabase.com)にログイン
2. プロジェクトを選択
3. **Authentication** → **Users** に移動
4. 既存のユーザー `hibari69+presentation@pm.me` を削除（あれば）
5. **Add user** ボタンをクリック
6. 以下を入力：
   - **Email**: `admin@example.com` （任意のメール）
   - **Password**: `Admin2025Contest` （シンプルなパスワード）
   - **Auto Confirm User**: ✅ **必ずチェック**
7. **Create user** をクリック

## 方法2: シンプルなパスワードで再作成

既存のユーザーでパスワードをリセット：

1. **Authentication** → **Users**
2. `hibari69+presentation@pm.me` を見つける
3. **...** メニュー → **Send password reset**
4. パスワードリセットメールが届かない場合は、ユーザーを削除して再作成

## テスト用の推奨設定

- **メール**: `admin@example.com`
- **パスワード**: `Admin2025Contest`（特殊文字なし）

## トラブルシューティング

### "Invalid login credentials" エラーが続く場合

1. **Authentication** → **Settings**
2. **Auth Providers** → **Email**
3. 以下を確認：
   - Enable Email provider: ✅ 有効
   - Confirm email: ❌ **無効**（開発環境）
   - Enable email confirmations: ❌ **無効**
   - Minimum password length: 6

### パスワードのヒント

避けるべき文字：
- `^` `#` `@` などの特殊文字の組み合わせ

推奨パスワード形式：
- 英数字 + 基本的な記号（!、.、-）
- 例: `Admin2025!`, `TestUser123.`

## 動作確認

1. ブラウザで `admin.html` を開く
2. キャッシュをクリア（Ctrl+Shift+R）
3. メールアドレスとパスワードを入力
4. ログイン

コンソールに詳細なデバッグ情報が表示されます。