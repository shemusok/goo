# goo - tiny command line Google API client

## Installation

```bash
$ git clone git@github.com:shemusok/goo.git  
$ cd ./goo && bundle install && rake install
```

## Usage

* Command line options help:
  ```bash
  $ goo help
  ```
* Get api/resources/method description:
  ```
  $ goo info webmasters.sitemaps.get
  ```
* Call method:
  ```bash
  $ goo call webmasters.sitemaps.get -p\
    feedpath:'http://example.com'\
    siteUrl: 'http://example.com/sitemap.xml'
  ```
  call **reply** will be printed as **YAML** to **STDOUT**

## Environment
  * **$GOO_EMAIL** or **-e** option - app service email
  * **$GOO_P12KEYFILE** or **-k** option - P12 key file path

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shemusok/goo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
