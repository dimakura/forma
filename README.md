# Forma

[![Build Status](https://travis-ci.org/dimakura/forma.png?branch=master)](https://travis-ci.org/dimakura/forma)

## Instalation

```
gem install forma
```

## Usage

```ruby
view_for @customer do |f|
  f.tab title: 'General', icon: 'general.png' do |f|
    f.text_field :first_name
    f.text_field :last_name
    f.text_field :mobile
    f.web_field :email
  end
  f.tab title: 'Sys Info', icon: 'sys.png' do |f|
    f.object_field :created_by, url: user_info_url(id: @customer.created_by.id)
    f.object_field :updated_by, url: user_info_url(id: @customer.updated_by.id)
    f.date_field :created_at
    f.date_field :updated_at
  end
end
```
