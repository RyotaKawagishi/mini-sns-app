# frozen_string_literal: true

# Keep each end-to-end scenario and its related assertions together.
# rubocop:disable RSpec/MultipleExpectations

require 'rails_helper'

RSpec.describe LikePolicy do
  subject(:policy) { described_class.new(actor, like) }

  let(:owner) { create(:user) }
  let(:like) { Like.new(user: owner, micropost: create(:micropost)) }

  context 'with its owner' do
    let(:actor) { owner }

    it 'allows create and destroy' do
      expect(policy.create?).to be(true)
      expect(policy.destroy?).to be(true)
    end
  end

  context 'with another user' do
    let(:actor) { create(:user) }

    it 'rejects create and destroy' do
      expect(policy.create?).to be(false)
      expect(policy.destroy?).to be(false)
    end
  end

  context 'without authentication' do
    let(:actor) { nil }

    it 'rejects create and destroy' do
      expect(policy.create?).to be(false)
      expect(policy.destroy?).to be(false)
    end
  end
end

# rubocop:enable RSpec/MultipleExpectations
