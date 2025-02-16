# ユーザーの作成
users = 5.times.map do |i|
  User.create!(
    github_login: "test_user#{i + 1}",
    name: "テストユーザー#{i + 1}",
    avatar: "https://example.com/avatars/#{i + 1}.jpg",
  )
end

# 写真の作成
photo_names = [
  "美しい夕日", "都会の風景", "山の頂上", "海辺の散歩道", "紅葉の森",
  "カフェでの一枚", "友達とのセルフィー", "コーディング中", "新しいガジェット", "休日の公園",
  "オフィスの様子", "美味しい料理", "週末の旅行", "ペットと一緒に", "趣味の時間",
  "読書の秋", "春の桜", "夏の花火", "冬の雪景色", "プログラミング本",
  "デスク周り", "モーニングコーヒー", "散歩中の発見", "お気に入りの場所", "夜景",
  "チームミーティング", "新しいプロジェクト", "ハッカソンの様子", "技術書の山", "リモートワーク"
]

photos = photo_names.map.with_index do |name, index|
  Photo.create!(
    name: name,
    url: "https://example.com/photos/#{index + 1}.jpg",
    description: "#{name}の説明文です。",
    category: Photo.categories.keys.sample,
    user: users.sample,
  )
end

# 写真タグの作成（各写真に1-3人のユーザーをランダムにタグ付け）
photos.each do |photo|
  # 投稿者以外のユーザーからランダムに選択
  taggable_users = users - [photo.user]
  tagged_count = rand(1..3)

  taggable_users.sample(tagged_count).each do |tagged_user|
    PhotoTag.create!(
      photo: photo,
      user: tagged_user,
    )
  end
end
