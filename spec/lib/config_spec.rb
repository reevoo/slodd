# encoding: utf-8
require "spec_helper"

describe Slodd::Config do
  subject { described_class }

  after(:each) do
    subject.reset
  end

  describe "attributes" do
    describe ".path" do
      it "has a default" do
        expect(subject.path).to eq "db/schema.rb"
      end

      it "can be overridden" do
        subject.path = "dingdong/schema.rb"
        expect(subject.path).to eq "dingdong/schema.rb"
      end
    end

    describe "github attrs" do
      before do
        subject.github = "errm/awesome_rails_app"
      end

      describe ".owner" do
        specify { expect(subject.owner).to eq "errm" }
      end

      describe ".repo" do
        specify { expect(subject.repo).to eq "awesome_rails_app" }
      end
    end

    describe ".username" do
      it "has a default" do
        expect(subject.username).to eq "root"
      end

      it "can be overridden" do
        subject.username = "mysqlusr"
        expect(subject.username).to eq "mysqlusr"
      end
    end

    describe ".password" do
      it "defaults to nil" do
        expect(subject.password).to be_nil
      end

      it "can be overridden" do
        subject.password = "mysqlpass"
        expect(subject.password).to eq "mysqlpass"
      end
    end

    describe ".url" do
      it "defaults to nil" do
        expect(subject.url).to be_nil
      end

      it "can be overridden" do
        subject.url = "http://some.site.com/schema.rb"
        expect(subject.url).to eq "http://some.site.com/schema.rb"
      end
    end

    describe ".fetcher" do
      it "defaults to Local" do
        expect(subject.fetcher.class).to eq Slodd::Local
      end

      it "returns Github if details are supplied" do
        subject.github = "errm/awesome_rails_app"
        subject.token = "oauth token"
        expect(subject.fetcher.class).to eq Slodd::Github
      end

      it "rasies an argument error if no github token is supplied" do
        subject.github = "errm/awesome_rails_app"
        expect { subject.fetcher }.to raise_error(ArgumentError)
      end

      it "rasies an argument error if the github string is malformed" do
        subject.github = "errm"
        subject.token = "oauth token"
        expect { subject.fetcher }.to raise_error(ArgumentError)
      end

      it "returns Http if a url is supplied" do
        subject.url = "http://some.url/schema.rb"
        expect(subject.fetcher.class).to eq Slodd::Http
      end
    end

    describe ".attributes" do
      context "Github" do
        it "returns all the arguments needed by github" do
          subject.github = "errm/awesome_rails_app"
          subject.token = "oauth token"
          subject.ref = "my-awesome-branch"
          attrs = {
            owner: "errm",
            repo: "awesome_rails_app",
            token: "oauth token",
            path: "db/schema.rb",
            ref: "my-awesome-branch",
          }
          expect(subject.attributes).to eq attrs
        end
      end

      context "Local" do
        it "returns all the arguments needed by Local" do
          attrs = {
            path: "db/schema.rb",
          }
          expect(subject.attributes).to eq attrs
        end
      end

      context "Http" do
        it "returns all the arguments needed by Http" do
          subject.url = "http://some.url.com/db/schema.rb"
          attrs = {
            path: "db/schema.rb",
            url: "http://some.url.com/db/schema.rb",
          }
          expect(subject.attributes).to eq attrs
        end
      end
    end

    describe ".databases" do
      it "defaults to empty array" do
        expect(subject.databases).to eq []
      end

      it "is an array of names" do
        subject.databases = "db1 db2 db3"
        expect(subject.databases).to eq %w(db1 db2 db3)
      end

      it "is an array of one name" do
        subject.databases = "db1"
        expect(subject.databases).to eq ["db1"]
      end
    end

    describe ".database_settings" do
      context "without a password" do
        it "returns the settings" do
          settings = {
            adapter: "mysql2",
            host: "localhost",
            username: "root",
          }
          expect(subject.database_settings).to eq settings
        end
      end

      context "with a password" do
        it "returns the settings" do
          subject.password = "brian"
          settings = {
            adapter: "mysql2",
            host: "localhost",
            username: "root",
            password: "brian",
          }
          expect(subject.database_settings).to eq settings
        end
      end

      context "with a database url in the environment" do
        before do
          ENV["DATABASE_URL"] = "mysql2://nova:sekret@127.0.0.1/foo_bar"
        end

        after do
          ENV["DATABASE_URL"] = nil
        end

        it "returns the settings" do
          settings = {
            adapter: "mysql2",
            host: "127.0.0.1",
            username: "nova",
            password: "sekret",
          }
          expect(subject.database_settings).to eq settings
        end

        it "sets the database" do
          expect(subject.databases).to eq ["foo_bar"]
        end
      end
    end

    describe ".host" do
      it "defaults to localhost" do
        expect(subject.host).to eq "localhost"
      end

      it "it can be overridden" do
        subject.host = "db1.something.com"
        expect(subject.host).to eq "db1.something.com"
      end
    end
  end
end
