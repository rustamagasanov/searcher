require 'rails_helper'

RSpec.describe JsonDbLoaderService do
  it { expect(described_class).to respond_to(:load) }
  it { expect{ described_class.load }.to_not raise_exception }
  it { expect(described_class.load).to be_kind_of(Array) }
end
