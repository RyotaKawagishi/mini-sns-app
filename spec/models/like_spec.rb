# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  subject(:like) { described_class.new(user: user, micropost: micropost) }

  let(:user) { create(:user) }
  let(:micropost) { create(:micropost) }

  # Bypass model validation to exercise the database constraint.
  # rubocop:disable Rails/SkipsModelValidations
  it 'prevents duplicate likes at the database level' do
    like.save!
    expect do
      # Deliberately bypass validation to verify the database constraint.
      described_class.insert_all!([{ user_id: user.id, micropost_id: micropost.id, created_at: Time.current,
                                     updated_at: Time.current }])
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  # rubocop:enable Rails/SkipsModelValidations

  it 'removes likes when the post is deleted' do
    like.save!
    expect { micropost.destroy! }.to change(described_class, :count).by(-1)
  end
end
