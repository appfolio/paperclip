# frozen_string_literal: true

case RUBY_VERSION
when '3.1.2', '3.2.1', '3.3.0'
  appraise "ruby-#{RUBY_VERSION}_rails61" do
    source 'https://rubygems.org' do
      gem 'rails', '~> 6.1.0'
    end
  end

  appraise "ruby-#{RUBY_VERSION}_rails70" do
    source 'https://rubygems.org' do
      gem 'rails', '~> 7.0.0'
    end
  end

  appraise "ruby-#{RUBY_VERSION}_rails71" do
    source 'https://rubygems.org' do
      gem 'rails', '~> 7.1.0'
    end
  end

  appraise "ruby-#{RUBY_VERSION}_rails72" do
    source 'https://rubygems.org' do
      gem 'rails', '~> 7.2.0'
    end
  end
else
  raise "Unsupported Ruby version #{RUBY_VERSION}"
end
