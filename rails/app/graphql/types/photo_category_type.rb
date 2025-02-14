# frozen_string_literal: true

module Types
  class PhotoCategoryType < Types::BaseEnum
    description 'Category of the photo'

    value 'SELFIE', 'A photo taken of oneself', value: :selfie
    value 'PORTRAIT', 'A portrait photo', value: :portrait
    value 'ACTION', 'An action photo', value: :action
    value 'LANDSCAPE', 'A landscape photo', value: :landscape
    value 'GRAPHIC', 'A graphic photo', value: :graphic
  end
end
