module Types
  class PhotoCategory < Types::BaseEnum
    description "写真のカテゴリー"

    value "SELFIE", "自分撮りの写真", value: "selfie"
    value "PORTRAIT", "ポートレート写真", value: "portrait"
    value "ACTION", "アクション写真", value: "action"
    value "LANDSCAPE", "風景写真", value: "landscape"
    value "GRAPHIC", "グラフィック写真", value: "graphic"
  end
end
