FactoryGirl.define do
  factory :category do
    sequence(:title) { |n| "Категория-№#{n}" }
    description 'Описание категории'
    priority 1
  end

  factory :article do
    sequence(:title) { |n| "Статья-№#{n}" }
    abstract 'Краткое содержание'
    body 'Полный текст'
    approved true
    published true
    category
  end

  factory :image do
    source File.open(File.join(Rails.root, 'spec/support/images/tiger.jpg'))

    factory :new_image do
      source File.open(File.join(Rails.root, 'spec/support/images/another image.jpg'))
    end
  end
end