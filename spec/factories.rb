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
end