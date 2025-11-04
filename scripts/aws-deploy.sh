#!/bin/bash

# AWS S3デプロイスクリプト
# 使用前に AWS CLI の設定が必要です: aws configure

# 変数設定
BUCKET_NAME="presentation-contest-2025"
REGION="ap-northeast-1"  # 東京リージョン
PROFILE="default"  # AWS CLIプロファイル

echo "🚀 AWS S3へのデプロイを開始します..."

# 1. S3バケットの作成
echo "📦 S3バケットを作成中..."
aws s3 mb s3://${BUCKET_NAME} --region ${REGION} --profile ${PROFILE} 2>/dev/null || echo "バケットは既に存在します"

# 2. 静的ウェブホスティングの有効化
echo "🌐 静的ウェブホスティングを設定中..."
aws s3 website s3://${BUCKET_NAME} \
    --index-document login.html \
    --error-document error.html \
    --profile ${PROFILE}

# 3. バケットポリシーの設定（パブリックアクセス許可）
echo "🔓 バケットポリシーを設定中..."
cat > bucket-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${BUCKET_NAME}/*"
        }
    ]
}
EOF

aws s3api put-bucket-policy \
    --bucket ${BUCKET_NAME} \
    --policy file://bucket-policy.json \
    --profile ${PROFILE}

# 4. パブリックアクセスブロックの設定を更新
echo "🔧 パブリックアクセス設定を更新中..."
aws s3api put-public-access-block \
    --bucket ${BUCKET_NAME} \
    --public-access-block-configuration \
    "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false" \
    --profile ${PROFILE}

# 5. ファイルのアップロード
echo "📤 ファイルをアップロード中..."

# HTMLファイル
aws s3 cp login.html s3://${BUCKET_NAME}/login.html \
    --content-type "text/html; charset=utf-8" \
    --cache-control "no-cache" \
    --profile ${PROFILE}

aws s3 cp index.html s3://${BUCKET_NAME}/index.html \
    --content-type "text/html; charset=utf-8" \
    --cache-control "no-cache" \
    --profile ${PROFILE}

aws s3 cp presenters.html s3://${BUCKET_NAME}/presenters.html \
    --content-type "text/html; charset=utf-8" \
    --cache-control "no-cache" \
    --profile ${PROFILE}

aws s3 cp admin.html s3://${BUCKET_NAME}/admin.html \
    --content-type "text/html; charset=utf-8" \
    --cache-control "no-cache" \
    --profile ${PROFILE}

# 動画ファイル
if [ -f "download.MP4" ]; then
    echo "🎥 動画をアップロード中（時間がかかる場合があります）..."
    aws s3 cp download.MP4 s3://${BUCKET_NAME}/download.MP4 \
        --content-type "video/mp4" \
        --cache-control "max-age=3600" \
        --profile ${PROFILE}
fi

# その他のファイル
aws s3 cp README.md s3://${BUCKET_NAME}/README.md \
    --content-type "text/markdown" \
    --profile ${PROFILE} 2>/dev/null || true

aws s3 cp SUPABASE_SETUP.md s3://${BUCKET_NAME}/SUPABASE_SETUP.md \
    --content-type "text/markdown" \
    --profile ${PROFILE} 2>/dev/null || true

aws s3 cp supabase_setup.sql s3://${BUCKET_NAME}/supabase_setup.sql \
    --content-type "text/plain" \
    --profile ${PROFILE} 2>/dev/null || true

# クリーンアップ
rm -f bucket-policy.json

# 6. サイトのURLを表示
echo ""
echo "✅ デプロイが完了しました！"
echo ""
echo "🌍 サイトURL:"
echo "http://${BUCKET_NAME}.s3-website-${REGION}.amazonaws.com"
echo ""
echo "📱 管理画面URL:"
echo "http://${BUCKET_NAME}.s3-website-${REGION}.amazonaws.com/admin.html"
echo ""
echo "💡 ヒント: CloudFrontを使用してHTTPSを有効にすることを推奨します"