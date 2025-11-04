-- 管理者ユーザー作成スクリプト
-- このスクリプトはSupabase SQL Editorで実行してください

-- 注意: このスクリプトを実行する前に、Supabaseダッシュボードの
-- Authentication > Providers でEmail認証が有効になっていることを確認してください

-- 管理者ユーザーの作成
-- パスワードは実行時に設定してください（最低6文字）
-- メールアドレス: admin@presentation-contest.local
--
-- Supabaseダッシュボードから以下の手順で作成してください：
-- 1. Authentication > Users に移動
-- 2. "Add user" をクリック
-- 3. Email: admin@presentation-contest.local
-- 4. Password: 強力なパスワードを設定（推奨: 16文字以上、英数字+記号）
-- 5. "Auto Confirm User" にチェック
-- 6. "Create user" をクリック

-- または、SQL Editorで以下を実行（パスワードは変更してください）:
/*
INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    recovery_sent_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    confirmation_token,
    email_change,
    email_change_token_new,
    recovery_token
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(),
    'authenticated',
    'authenticated',
    'admin@presentation-contest.local',
    crypt('YOUR_SECURE_PASSWORD_HERE', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"role":"admin"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
);
*/

-- セキュリティのベストプラクティス:
-- 1. パスワードは16文字以上
-- 2. 英大文字、英小文字、数字、記号を含める
-- 3. このSQLファイルにパスワードを書かない
-- 4. パスワードマネージャーで管理する
-- 5. 定期的にパスワードを変更する
