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

  images = ['tiger.jpg', 'another image.jpg', 'blue fish.jpg', 'yellow sun.jpg'].map { |file| 'spec/support/images/' + file }

  factory :image_path, class: String do
    sequence(:path) { |n| images[n % images.size] }

    initialize_with { new(path) }
  end

  factory :image, aliases: [:avatar] do
    sequence(:source) { |n| File.open(File.join(Rails.root, images[n % images.size])) }
  end

  factory :user do
    sequence(:email) { |n| "user-#{n}@tomkovcheg.ru" }
    sequence(:nickname) { |n| "user#{n}" }
    sequence(:password) { |n| "password_#{n}" }
    password_confirmation { |u| u.password }

    factory :admin do
      sequence(:email) { |n| "admin-#{n}@tomkovcheg.ru" }
      role Role.admin
    end

    factory :moderator do
      sequence(:email) { |n| "moderator-#{n}@test.com" }
      role Role.moderator
    end
  end

  factory :authentication do
    sequence(:uid) { |n| n + 10000 }
    sequence(:provider) { |n| ['facebook', 'vkontakte'][n % 2] }
  end

  factory :comment do
    sequence(:body) { |n| "This is my very important comment #{n}" }
  end
end