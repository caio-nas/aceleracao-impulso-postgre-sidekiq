# frozen_string_literal: true

FactoryBot.define do
  factory :buyer do
    name { FFaker::NameBR.name }
    email { FFaker::InternetSE.free_email(name) }
  end
end