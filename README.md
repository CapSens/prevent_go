# PreventGO

Ruby gem made to use PreventGO OCR in your applications.
Official documentation is available [here](https://www.preventgo.io/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prevent_go'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install prevent_go

## Configuration

Create an account on [PreventGO website](https://www.preventgo.io/) and ask for API keys.

And then add an initializer

```ruby
# config/initializers/prevent_go.rb

PreventGo.configure do |config|
  config.site_key = 'YOUR_PUBLIC_SITE_KEY'
  config.secret_key = 'YOUR_SECRET_KEY'
  config.api_root_url = 'API_ENDPOINT'
end
```

## Usage

Parent module

```ruby
    module PreventGo
```

Each type of document that can be verified has his own class as follow:

```ruby
    PreventGo::BankAccount
    PreventGo::Identity
    PreventGo::PropertyTaxNotice
    PreventGo::TaxNotice
    PreventGo::ProviderInvoice
```

Each instance of one of the previous classes can be initialized as following:

```ruby
  PreventGo::BankAccount.new(file, file_back, params)
```
- `:file`:      mandatory - can be a path or IO file
- `:file_back`: optional - can be a path or IO file
- `params`:     optional - ask preventGo to make additional controls on documents (details per document below)


And can access to thoses methods

| method               | Description | 
|----------------------|-------------|
| `.document_type`     | return document type as string |
| `.document_details`  | return a hash with informations givent by the API or an empty hash |
| `.document_controls` | return a hash with the api response on control_groups about document or an empty hash |
| `.holder_controls`   | return a hash with the api response on control_groups about document holder or an empty hash |
| `.quality_validated?`| return a boolean with api response on document quality |

------

`PreventGo::BankAccount`

optional params to pass to bank_account validation are:
- holder: { "firstName":"Scarlette", "birthName":"Johansson", "lastName":"Bauer"} or {"legalEntityName":"NETHEOS"}
- bank_account: { "iban":"FR7600000000000000000000000", "bicCode":"AGRIFRPP" }

example:
```ruby
  PrevenGo::BankAccount.new(
    file,
    holder: {legalEntityName:"NETHEOS"},
    bank_account: {iban: "FR7600000000000000000000000"}
  )
```

additional instance methods available:
- `:iban`
- `:bic`
------

`PreventGo::Identity`

Individual person identity document, can be either ID card, passport or driver license

optional params to pass to bank_account validation are:
- holder: { "firstName":"John", "birthName":"Doe", "lastName":"Simpson", "birthDate":"1987-12-25", "gender":"M" }

example:
```ruby
  PrevenGo::Identity.new(
    file,
    holder: {"firstName":"John", "birthName":"Doe"}
  )
```

additional instance methods available:
- `:iban`
- `:bic`

------

`PreventGo::PropertyTaxNotice`

optional params to pass to bank_account validation are:
- holder: { "firstName":"James","lastName":"Bond","birthName": "Martinet","address": {"address1":"29 rue du Cheval blanc", "postalCode":"34000", "city":"Montpellier"}}

example:
```ruby
  PrevenGo::PropertyTaxNotice.new(
    file,
    holder: {"firstName":"John", "birthName":"Doe"}
  )
```
------

`PreventGo::TaxNotice`

Only works with french tax notices

optional params to pass to bank_account validation are:
- holder_1: { "firstName":"James","lastName":"Bond" }
- holder_2: { "firstName":"James","lastName":"Bond" }
- taxHouseHold: {
  "familyStatusCode":"SINGLE",
  "partsCount":1.5,
  "dependentPersonsCount":2,
  "globalGrossIncome":23456,
  "referenceIncome":12345,
  "taxableIncome":1234,
  "taxAmount":123,
   "address": {"address1":"29 rue du Cheval anc","postalCode":"34000","city":"Montpellier"}
}

example:
```ruby
  PrevenGo::TaxNotice.new(
    file,
    holder_1: {"firstName":"John", "birthName":"Do"},
    holder_2: {"firstName":"Jane", "birthName":"Undo"}
  )
```
------

`PreventGo::ProviderInvoice`

Provider invoice or schedule accepted

optional params to pass to bank_account validation are:
- holder: { "firstName":"James","lastName":"Bond","birthName": "Martinet","address": {"address1":"29 rue du Cheval blanc", "postalCode":"34000", "city":"Montpellier"}}

example:
```ruby
  PrevenGo::ProviderInvoice.new(
    file,
    holder: {"firstName":"John", "birthName":"Doe"}
  )
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CapSens/prevent_go

1. **Fork** the repo on GitHub
2. **Clone** the project to your own machine
3. **Commit** changes to your own branch
4. **Push** your work back up to your fork
5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PreventGo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Capsens/prevent_go/blob/master/CODE_OF_CONDUCT.md).
