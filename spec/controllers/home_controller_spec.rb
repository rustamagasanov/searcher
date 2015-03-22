require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe '#index' do
    it { expect(get: '/').to route_to('home#index') }
    it { expect(get :index).to render_template(:index) }
  end

  describe '#search' do
    let(:q) { 'search query' }

    before do
      allow(SearchService).to receive(:new).and_return(@service_instance = double)
      allow(@service_instance).to receive(:run)
    end

    it { expect(get: '/search').to route_to('home#search') }
    it { expect(get :search).to render_template(:search) }

    it 'should initialize search service with search string' do
      expect(SearchService).to receive(:new).with(q)
      get :search, q: q
    end

    it 'should call run on search service instance' do
      expect(@service_instance).to receive(:run)
      get :search, q: q
    end
  end
end
