# frozen_string_literal: true

FactoryBot.define do
  factory :seller do
    name { FFaker::NameBR.name }
    email { FFaker::InternetSE.free_email(name) }
  end
end