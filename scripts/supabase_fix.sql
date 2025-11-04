-- Supabase権限修正SQL
-- このSQLをSupabaseのSQL Editorで実行してください

-- 1. RLSポリシーを一度削除して再作成
DROP POLICY IF EXISTS "Allow public read access codes" ON access_codes;
DROP POLICY IF EXISTS "Allow public insert access logs" ON access_logs;

-- 2. 新しいポリシーを作成（読み書き両方を許可）
CREATE POLICY "Allow all operations on access_codes" ON access_codes
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all operations on access_logs" ON access_logs
    FOR ALL USING (true) WITH CHECK (true);

-- 3. テーブルの権限を確認
GRANT ALL ON access_codes TO anon;
GRANT ALL ON access_logs TO anon;

-- 4. データベース関数の権限
GRANT USAGE ON SCHEMA public TO anon;
GRANT CREATE ON SCHEMA public TO anon;

-- 5. シーケンスの権限（IDの自動生成）
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;