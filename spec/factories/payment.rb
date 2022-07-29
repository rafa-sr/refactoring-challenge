# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    association :agent, factory: :agent
    association :contract, factory: :contract
    amount_cents { rand(1..1_000) }
    new { true }
    processed { false }
    exported_at { Time.now }
  end
end
