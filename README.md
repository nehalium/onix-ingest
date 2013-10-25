onix-ingest
===========

A simple application for ingesting ONIX feeds.

# Installation

1. Install [Base-X](http://basex.org/)
1. Install [Ruby 1.9.3](https://www.ruby-lang.org/en/downloads/)
1. Install the following Ruby gem:
	* RubyZip: `gem install rubyzip`
	* Nokogiri: `gem install nokogiri`
	* MySQL: `gem install mysql`
1. Clone source to installation directory
1. Make sure the database objects in sql/script.sql have been created

# Usage

1. Configure `config.rb` for your environment
1. Start the Base-X server
1. Run main.rb:

	`main.rb`

# Price Determination Rules

The following outlines the rules used to determine the list price and the net price:

NOTE: it is important not to deduce the net price before the list price and in all cases, the denomination = currencyCode

## First, the list price

1. If a priceTypeCode of 01 exists, then price = its priceAmount
1. Else, if a priceTypeCode of 05 exists, then price = (its priceAmount / 0.75)
1. Else, if a priceTypeCode of 11 exists, then price = its priceAmount
1. Else, if a priceTypeCode of 21 exists, then price = its priceAmount
1. Else, leave blank

## Second, the net price

1. If a priceTypeCode of 05 exists, then netPrice = its priceAmount
1. Else, if a priceTypeCode of 15 exists, then netPrice = its priceAmount
1. Else, if a priceTypeCode of 25 exists, then netPrice = its priceAmount
1. Else, if a list price exists then netPrice = (non-priceTypeCode-11-deduced list price0.75)
1. Else, leave blank

The preceeding rules will be applied to the US currency first, if found.
If US currency is not found then we will apply the rules to Canadian currency.

