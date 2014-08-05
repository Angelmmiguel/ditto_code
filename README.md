# DittoCode

![DittCode](https://raw.githubusercontent.com/Angelmmiguel/ditto_code/master/ditto.png "DittoCode")

DittoCode helps you to transform and execute your ruby code based on a custom variable. This gem is composed by a "execute" block to development your app, and a parser who rewrite your code ready to production.

## Why DittoCode?

When you need to divide a software into multiples releases like Free, Pro, Premium..., you could need to divide your code in several repositories. 

DittoCode can execute your code based on a environment variable called: DITTOCODE_ENV. This variable switch the code to the correct release.

## How?

It's simple, with DittoCode you will be able to create a blocks that will be executed only when the DITTOCODE_ENV coincide with the environment of the block:

	DittoCode::Exec.if 'PREMIUM' do

		# Your premium code!

	end

These blocks are for development. When you turn to production, call to Ditto to atack!. In a terminal:

	dittoc PREMIUM my_file.rb

This parser will rewrite your code and create a new file called my_file_PREMIUM.rb that hold the code inside the "PREMIUM" blocks, and delete the code inside anothers blocks.

But... I want to rewrite the file, don't create a new :/. No problem:

	dittoc -o PREMIUM my_file.rb

This will override your file.