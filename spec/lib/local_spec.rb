# encoding: utf-8
require 'spec_helper'

describe Slodd::Local do
  subject { described_class.new(path: schema_path) }

  describe '#schema' do
    it 'reads the file' do
      expect(subject.schema).to eq File.read(schema_path)
    end
  end
end
