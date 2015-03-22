require 'rails_helper'

RSpec.describe SearchService do
  before do
    @data = []

    @data[0] = {
      "Name" => "A+",
      "Type" => "Array",
      "Designed by" => "Arthur Whitney"
    }

    @data[1] = {
      "Name" => "APL",
      "Type" => "Array, Interactive mode, Interpreted",
      "Designed by" => "Kenneth E. Iverson"
    }

    @data[2] = {
      "Name" => "Common Lisp",
      "Type" => "Compiled, Interactive mode, Object-oriented class-based, Reflective",
      "Designed by" => "Scott Fahlman, Richard P. Gabriel, Dave Moon, Guy Steele, Dan Weinreb"
    }

    @data[3] = {
      "Name" => "K",
      "Type" => "Array",
      "Designed by" => "Arthur Whitney"
    }

    @relevant0 = @data[0].merge({rel: 0})
    @relevant1 = @data[1].merge({rel: 0})
    @relevant2 = @data[2].merge({rel: 0})
    @relevant3 = @data[3].merge({rel: 0})

    @part_relevant0 = @data[0].merge({rel: 1})
    @part_relevant1 = @data[1].merge({rel: 1})
    @part_relevant2 = @data[2].merge({rel: 1})
    @part_relevant3 = @data[3].merge({rel: 1})

    allow_any_instance_of(described_class).to receive(:data).and_return(@data)
  end

  it { expect(described_class).to respond_to(:new) }
  it { expect(described_class.new).to respond_to(:run) }

  describe '#run' do
    describe 'should find exact word' do
      it { expect(described_class.new('Array').run).to include(@relevant0) }
    end

    describe 'should find exact word in list' do
      it { expect(described_class.new('Array').run).to include(@relevant0) }
      it { expect(described_class.new('Array').run).to include(@relevant1) }
    end

    describe 'should not include incorrect results' do
      it { expect(described_class.new('Array').run).to_not include(@relevant2) }
    end

    describe 'should be case insensitive' do
      it { expect(described_class.new('array').run).to include(@relevant0) }
      it { expect(described_class.new('array').run).to include(@relevant1) }
    end

    describe 'should find multiple words' do
      it { expect(described_class.new('arthur whitney').run).to include(@relevant0) }
    end

    describe 'should find matches' do
      it { expect(described_class.new('arr').run).to include(@relevant0) }
      it { expect(described_class.new('arr').run).to include(@relevant1) }
      it { expect(described_class.new('comm').run).to include(@relevant2) }
    end

    describe 'should find words in any order' do
      it { expect(described_class.new('whitney arthur').run).to include(@relevant0) }
      it { expect(described_class.new('lisp common').run).to include(@relevant2) }
    end

    describe 'should add {rel: 0} if all words were found' do
      it { expect(described_class.new('whitney arthur').run).to include(@relevant0) }
    end

    describe 'should add {rel: 1} if not all words were found' do
      it { expect(described_class.new('whitney michael').run).to include(@part_relevant0) }
    end

    describe 'should sort results by relevance' do
      it { expect(described_class.new('k arthur').run).to eql([@relevant3, @part_relevant1, @part_relevant0]) }
    end

    describe 'should return exact programming language name if found' do
      it { expect(described_class.new('k').run).to include(@relevant3) }
    end

    describe 'should skip quotes' do
      it { expect(described_class.new("'k'").run).to include(@relevant3) }
    end
  end
end
