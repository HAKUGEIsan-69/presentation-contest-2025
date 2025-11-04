-- Supabase SQL Editor で実行するSQL

-- 1. アクセスコード管理テーブルの作成
CREATE TABLE IF NOT EXISTS access_codes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    is_active BOOLEAN DEFAULT true,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE -- 有効期限（オプション）
);

-- 2. アクセスログテーブルの作成（オプション）
CREATE TABLE IF NOT EXISTS access_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    access_code VARCHAR(50),
    accessed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address VARCHAR(45),
    user_agent TEXT
);

-- 3. 初期データの挿入
INSERT INTO access_codes (code, description)
VALUES
    ('UEKUSA2025', 'メインアクセスコード'),
    ('GUEST2025', 'ゲスト用アクセスコード')
ON CONFLICT (code) DO NOTHING;

-- 4. RLS（Row Level Security）の有効化
ALTER TABLE access_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_logs ENABLE ROW LEVEL SECURITY;

-- 5. ポリシーの作成（読み取り専用）
CREATE POLICY "Allow public read access codes" ON access_codes
    FOR SELECT USING (is_active = true);

CREATE POLICY "Allow public insert access logs" ON access_logs
    FOR INSERT WITH CHECK (true);

-- 6. 更新日時を自動更新する関数
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 7. トリガーの作成
CREATE TRIGGER update_access_codes_updated_at
    BEFORE UPDATE ON access_codes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();