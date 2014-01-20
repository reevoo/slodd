require "spec_helper"

describe Slodd::Github do
  let(:owner) { "errm" }
  let(:repo)  { "awesome_rails_app" }
  let(:path)  { "db/schema.rb" }
  let(:token) { "secret-oauth-token" }
  let(:ref)   { nil }

  let(:schema) { double(read: nil) }

  subject do
    described_class.new(owner, repo, path, token, ref)
  end

  describe "#schema" do
    it "hits the correct url" do
      allow(subject).to receive(:open) do |url, _|
        expect(url).to eq(
          "https://api.github.com/repos/#{owner}/#{repo}/contents/#{path}"
        )
        schema
      end

      subject.schema
    end

    context "with a ref" do
      let(:ref) { "exciting-feature-branch" }

      it "hits a url including the ref param" do
        allow(subject).to receive(:open) do |url, _|
          expect(url).to eq(
            "https://api.github.com/repos/#{owner}/#{repo}/contents/#{path}?ref=#{ref}"
          )
          schema
        end

        subject.schema
      end
    end

    context "with a blank ref" do
      let(:ref) { "" }

      it "hits a url without the ref param" do
        allow(subject).to receive(:open) do |url, _|
          expect(url).to eq(
            "https://api.github.com/repos/#{owner}/#{repo}/contents/#{path}"
          )
          schema
        end

        subject.schema
      end
    end

    it "uses the correct token" do
      allow(subject).to receive(:open) do |_, headers|
        expect(headers["Authorization"]).to eq "token #{token}"
        schema
      end

      subject.schema
    end

    it "requests the raw mediatype" do
      allow(subject).to receive(:open) do |_, headers|
        expect(headers["Accept"]).to eq "application/vnd.github.3.raw"
        schema
      end

      subject.schema
    end

    it "returns the schema" do
      allow(subject).to receive(:open).and_return(schema)
      allow(schema).to receive(:read).and_return("the schema")
      expect(subject.schema).to eq "the schema"
    end
  end
end
