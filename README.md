[![Gem Version](https://badge.fury.io/rb/ditto_code.svg)](http://badge.fury.io/rb/ditto_code) [![Build Status](https://travis-ci.org/Angelmmiguel/ditto_code.svg?branch=master)](https://travis-ci.org/Angelmmiguel/ditto_code)

# DittoCode

![DittoCode](https://raw.githubusercontent.com/Angelmmiguel/ditto_code/master/ditto.png "DittoCode")

DittoCode helps you to transform and execute your ruby code based on a custom environment variable. This gem is composed by a "execute" block to development your app, and a parser who rewrite your code ready to production.

## Why use DittoCode?

When you need to divide an application into multiples releases like Free, Pro, Premium..., you could need to divide your code in several repositories. 

DittoCode can execute your code based on a environment variable called: DITTOCODE_ENV. This variable switch the code to the correct release.

## Installation

    gem install ditto_code
    
## How?

### Development

#### Execute the file or start a server

To execute a file based on a custom release use:

	DITTOCODE_ENV=PREMIUM ruby my_file.rb

If you are using a framework like rails:

	DITTOCODE_ENV=PREMIUM rails s

#### Switch a piece of code in a file

It's simple, with DittoCode you will be able to create a blocks that will be executed only when the DITTOCODE_ENV coincide with the environment of the block:

	DittoCode::Exec.if 'PREMIUM' do

		# Your premium code!

	end

You can add multiple environments:

	DittoCode::Exec.if 'PREMIUM,PRO' do

		# Your premium and pro code!

	end

This blocks can be used in your .erb files like js or html:

    <% DittoCode::Exec.if 'PREMIUM' do %>

		// Your css, js... premium code!

	<% end %>

#### Inline conditionals

The method to use inline conditional is *Exec.is*. For example, if you wants to execute the method *call_to_method* if the release is 'PRO':

	call_to_method if DittoCode::Exec.is 'PRO'

#### Switch an entirely file

You can have a file that you don't want copy in some releases. For example, if you have a *premium.js*, this file mustn't appear in free release. To solve this situation, you have two methods.

For ruby files:

    DittoCode::HoldFile.if 'PREMIUM'

This code only hold the file in the PREMIUM release. On the other hand:

    DittoCode::RemoveFile.if 'FREE,PRO'
    
This sentence will remove this file in FREE and PRO releases.

The same methods are available in .erb:

    <% DittoCode::HoldFile.if 'PREMIUM' %>
    <% DittoCode::RemoveFile.if 'FREE,PRO' %>

### Production

Those blocks are for development. When you turn to production, you can call to Ditto to attack!. In a terminal:

	dittoc PREMIUM my_file.rb

**dittoc** is a parser will rewrite your code and create a new file called my_file_PREMIUM.rb (in this example) that hold the code inside the "PREMIUM" blocks, and delete the code inside another blocks.

If you want to override the file use -o option:

	dittoc -o PREMIUM my_file.rb
	
To iterate inside a folder use -f option:

    dittoc -f PREMIUM ./
    
To iterate recursively inside a folder use -r option:

    dittoc -f -r PREMIUM ./

By default, dittoc ignore the .erb files. If you need to parse it use the option --allow-views:

	dittoc -f -r --allow-views PREMIUM ./
    
## Contributions

Feels free to open a ticket or a pull request. You can connect with me at: [@Laux_es](https://twitter.com/Laux_es "Laux_es") ;)

## License 

DittoCode is released under the MIT License.
