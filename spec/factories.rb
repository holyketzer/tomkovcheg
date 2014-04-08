FactoryGirl.define do
  factory :category do
    sequence(:title) { |n| "Категория-№#{n}" }
    description 'Описание категории'
    priority 1
  end
end