require 'spec_helper'
require 'paperclip/schema'
require 'active_support/testing/deprecation'

describe Paperclip::Schema do
  include ActiveSupport::Testing::Deprecation

  before do
    rebuild_class
  end

  after do
    Dummy.connection.drop_table :dummies rescue nil
  end

  context "within table definition" do
    context "using #has_attached_file" do
      it "creates attachment columns" do
        Dummy.connection.create_table :dummies, force: true do |t|
          t.has_attached_file :avatar
        end

        columns = Dummy.columns.map{ |column| [column.name, column.sql_type] }

        # Column types updated for mysql instead of sqlite
        expect(columns).to include(['avatar_file_name', "varchar(255)"])
        expect(columns).to include(['avatar_content_type', "varchar(255)"])
        expect(columns).to include(['avatar_file_size', "bigint(20)"])
        expect(columns).to include(['avatar_updated_at', "datetime#{ '(6)' if ActiveSupport.version >= Gem::Version.new('7') }"])
      end
    end

    context "using #attachment" do
      before do
        Dummy.connection.create_table :dummies, force: true do |t|
          t.attachment :avatar
        end
      end

      it "creates attachment columns" do
        columns = Dummy.columns.map{ |column| [column.name, column.sql_type] }

        # Column types updated for mysql instead of sqlite
        expect(columns).to include(['avatar_file_name', "varchar(255)"])
        expect(columns).to include(['avatar_content_type', "varchar(255)"])
        expect(columns).to include(['avatar_file_size', "bigint(20)"])
        expect(columns).to include(['avatar_updated_at', "datetime#{ '(6)' if ActiveSupport.version >= Gem::Version.new('7') }"])
      end
    end

    context "using #attachment with options" do
      before do
        Dummy.connection.create_table :dummies, force: true do |t|
          # Default updated_at needed for mysql instead of sqlite
          t.attachment :avatar, content_type: { default: '1' }, file_size: { default: 1 }, file_name: { default: 'default' }, updated_at: { default: Time.now }
        end
      end

      it "sets defaults on columns" do
        defaults_columns = ["avatar_file_name", "avatar_content_type", "avatar_file_size"]
        columns = Dummy.columns.select { |e| defaults_columns.include? e.name }

        expect(columns).to have_column("avatar_file_name").with_default("default")
        expect(columns).to have_column("avatar_content_type").with_default("1")
        expect(columns).to have_column("avatar_file_size").with_default(1)
      end
    end
  end

  context "within schema statement" do
    before do
      Dummy.connection.create_table :dummies, force: true
    end

    context "migrating up" do
      context "with single attachment" do
        before do
          Dummy.connection.add_attachment :dummies, :avatar
        end

        it "creates attachment columns" do
          columns = Dummy.columns.map{ |column| [column.name, column.sql_type] }

          # Column types updated for mysql instead of sqlite
          expect(columns).to include(['avatar_file_name', "varchar(255)"])
          expect(columns).to include(['avatar_content_type', "varchar(255)"])
          expect(columns).to include(['avatar_file_size', "bigint(20)"])
          expect(columns).to include(['avatar_updated_at', "datetime#{ '(6)' if ActiveSupport.version >= Gem::Version.new('7') }"])
        end
      end

      context "with single attachment and options" do
        before do
          Dummy.connection.add_attachment :dummies, :avatar, content_type: { default: '1' }, file_size: { default: 1 }, file_name: { default: 'default' }
        end

        it "sets defaults on columns" do
          defaults_columns = ["avatar_file_name", "avatar_content_type", "avatar_file_size"]
          columns = Dummy.columns.select { |e| defaults_columns.include? e.name }

          expect(columns).to have_column("avatar_file_name").with_default("default")
          expect(columns).to have_column("avatar_content_type").with_default("1")
          expect(columns).to have_column("avatar_file_size").with_default(1)
        end
      end

      context "with multiple attachments" do
        before do
          Dummy.connection.add_attachment :dummies, :avatar, :photo
        end

        it "creates attachment columns" do
          columns = Dummy.columns.map{ |column| [column.name, column.sql_type] }

          # Column types updated for mysql instead of sqlite
          expect(columns).to include(['avatar_file_name', "varchar(255)"])
          expect(columns).to include(['avatar_content_type', "varchar(255)"])
          expect(columns).to include(['avatar_file_size', "bigint(20)"])
          expect(columns).to include(['avatar_updated_at', "datetime#{ '(6)' if ActiveSupport.version >= Gem::Version.new('7') }"])
          expect(columns).to include(['photo_file_name', "varchar(255)"])
          expect(columns).to include(['photo_content_type', "varchar(255)"])
          expect(columns).to include(['photo_file_size', "bigint(20)"])
          expect(columns).to include(['photo_updated_at', "datetime#{ '(6)' if ActiveSupport.version >= Gem::Version.new('7') }"])
        end
      end

      context "with multiple attachments and options" do
        before do
          Dummy.connection.add_attachment :dummies, :avatar, :photo, content_type: { default: '1' }, file_size: { default: 1 }, file_name: { default: 'default' }
        end

        it "sets defaults on columns" do
          defaults_columns = ["avatar_file_name", "avatar_content_type", "avatar_file_size", "photo_file_name", "photo_content_type", "photo_file_size"]
          columns = Dummy.columns.select { |e| defaults_columns.include? e.name }

          expect(columns).to have_column("avatar_file_name").with_default("default")
          expect(columns).to have_column("avatar_content_type").with_default("1")
          expect(columns).to have_column("avatar_file_size").with_default(1)
          expect(columns).to have_column("photo_file_name").with_default("default")
          expect(columns).to have_column("photo_content_type").with_default("1")
          expect(columns).to have_column("photo_file_size").with_default(1)
        end
      end

      context "with no attachment" do
        it "raises an error" do
          assert_raises ArgumentError do
            Dummy.connection.add_attachment :dummies
          end
        end
      end
    end

    context "migrating down" do
      before do
        Dummy.connection.change_table :dummies do |t|
          t.column :avatar_file_name, :string
          t.column :avatar_content_type, :string
          t.column :avatar_file_size, :bigint
          t.column :avatar_updated_at, :datetime
        end
      end

      context "using #drop_attached_file" do
        it "removes the attachment columns" do
          Dummy.connection.drop_attached_file :dummies, :avatar

          columns = Dummy.columns.map{ |column| [column.name, column.sql_type] }

          # Column types updated for mysql instead of sqlite
          expect(columns).to_not include(['avatar_file_name', "varchar(255)"])
          expect(columns).to_not include(['avatar_content_type', "varchar(255)"])
          expect(columns).to_not include(['avatar_file_size', "bigint(20)"])
          expect(columns).to_not include(['avatar_updated_at', "datetime#{ '(6)' if ActiveSupport.version >= Gem::Version.new('7') }"])
        end
      end

      context "using #remove_attachment" do
        context "with single attachment" do
          before do
            Dummy.connection.remove_attachment :dummies, :avatar
          end

          it "removes the attachment columns" do
            columns = Dummy.columns.map{ |column| [column.name, column.sql_type] }

            # Column types updated for mysql instead of sqlite
            expect(columns).to_not include(['avatar_file_name', "varchar(255)"])
            expect(columns).to_not include(['avatar_content_type', "varchar(255)"])
            expect(columns).to_not include(['avatar_file_size', "bigint(20)"])
            expect(columns).to_not include(['avatar_updated_at', "datetime#{ '(6)' if ActiveSupport.version >= Gem::Version.new('7') }"])
          end
        end

        context "with multiple attachments" do
          before do
            Dummy.connection.change_table :dummies do |t|
              t.column :photo_file_name, :string
              t.column :photo_content_type, :string
              t.column :photo_file_size, :bigint
              t.column :photo_updated_at, :datetime
            end

            Dummy.connection.remove_attachment :dummies, :avatar, :photo
          end

          it "removes the attachment columns" do
            columns = Dummy.columns.map{ |column| [column.name, column.sql_type] }

            # Column types updated for mysql instead of sqlite
            expect(columns).to_not include(['avatar_file_name', "varchar(255)"])
            expect(columns).to_not include(['avatar_content_type', "varchar(255)"])
            expect(columns).to_not include(['avatar_file_size', "bigint(20)"])
            expect(columns).to_not include(['avatar_updated_at', "datetime#{ '(6)' if ActiveSupport.version >= Gem::Version.new('7') }"])
            expect(columns).to_not include(['photo_file_name', "varchar(255)"])
            expect(columns).to_not include(['photo_content_type', "varchar(255)"])
            expect(columns).to_not include(['photo_file_size', "bigint(20)"])
            expect(columns).to_not include(['photo_updated_at', "datetime#{ '(6)' if ActiveSupport.version >= Gem::Version.new('7') }"])
          end
        end

        context "with no attachment" do
          it "raises an error" do
            assert_raises ArgumentError do
              Dummy.connection.remove_attachment :dummies
            end
          end
        end
      end
    end
  end
end
