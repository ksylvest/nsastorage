# NSAStorage

[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ksylvest/nsastorage/blob/main/LICENSE)
[![RubyGems](https://img.shields.io/gem/v/nsastorage)](https://rubygems.org/gems/nsastorage)
[![GitHub](https://img.shields.io/badge/github-repo-blue.svg)](https://github.com/ksylvest/nsastorage)
[![Yard](https://img.shields.io/badge/docs-site-blue.svg)](https://nsastorage.ksylvest.com)
[![CircleCI](https://img.shields.io/circleci/build/github/ksylvest/nsastorage)](https://circleci.com/gh/ksylvest/nsastorage)

A Ruby library offering both a CLI and API for scraping [NSA Storage](https://www.nsastorage.com/) self-storage facilities and prices.

## Installation

```bash
gem install nsastorage
```

## Configuration

```ruby
require 'nsastorage'

NSAStorage.configure do |config|
  config.user_agent = '../..' # ENV['NSASTORAGE_USER_AGENT']
  config.timeout = 30 # ENV['NSASTORAGE_TIMEOUT']
  config.proxy_url = 'http://user:pass@superproxy.zenrows.com:1337' # ENV['NSASTORAGE_PROXY_URL']
end
```

## Usage

```ruby
require 'nsastorage'

sitemap = NSAStorage::Facility.sitemap
sitemap.links.each do |link|
  url = link.loc
  facility = NSAStorage::Facility.fetch(url:)

  puts facility.text

  facility.prices.each do |price|
    puts price.text
  end

  puts
end
```

## CLI

```bash
nsastorage crawl
```

```bash
nsastorage crawl "https://www.nsastorage.com/storage/georgia/storage-units-norcross/1-Western-Hills-Ct-2"
```
