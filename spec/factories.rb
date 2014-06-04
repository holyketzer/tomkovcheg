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
    published true
    category
  end

  factory :image do
    source File.open(File.join(Rails.root, 'spec/support/images/tiger.jpg'))

    factory :new_image do
      source File.open(File.join(Rails.root, 'spec/support/images/another image.jpg'))
    end
  end

  factory :user do
    sequence(:email) { |n| "user-#{n}@tomkovcheg.ru" }
    password '12345678'
    password_confirmation '12345678'
  end
end