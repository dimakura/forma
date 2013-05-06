# Forma

[![Build Status](https://travis-ci.org/dimakura/forma.png?branch=master)](https://travis-ci.org/dimakura/forma)

`Forma` is usefull to easily create rich web forms with ruby web-frameworks.

Standard rails forms are great.
There are also nice libraries for creating some common elements, like SimpleForms.

`Forma` is intended for projects with huge amount of forms.
It scales easily and without pain.

## Instalation and usage

Include

  gem 'forma'

into your Gemfile. Or use

  gem install forma

For proper functionality you should also include `jquery` (v > 1.9).

TODO: css & js inclusion ... etc.

## Usage

```ruby
forma_for @user, title: 'Register', url: register_path do |f|
  f.text_field :username
  f.password_field :password
  f.password_field :password_confirmation
  f.text_field :first_name
  f.text_field :last_name
  f.text_field :mobile
  f.web_field :email
end
```

TODO: more advanced usage of forms