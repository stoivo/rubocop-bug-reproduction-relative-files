# frozen_string_literal: true

FactoryBot.define do
  factory :accounting_office do
    id do AccountingOffice.last && (AccountingOffice.last.id + 1) || 1 end
    name do id == 1 ? 'FakturaBank' : "Acc Off #{Time.now}" end
    initialize_with { AccountingOffice.where(id:, name:).first_or_create }
  end
end
