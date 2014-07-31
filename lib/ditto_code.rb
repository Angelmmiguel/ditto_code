class DittoCode

	# Say hello ditto
  def self.hi
    puts "Hi man! What's up?"
  end

  # Initialize the environment
  def initialize(environment)
    @env = environment;
  end

  # Transform the file based in the environment
  def transform(file_path)

    # Start to read the file
    file = File.open(file_path)
    file_name = File.basename(file_path, ".rb") 

    # Get the text
    text = file.read

    # Generate the new archive
    out_file = File.new("#{file_name}_#{@env}.rb", "w")

    dittos = 0;
    actions = {}

    # Each line........
    text.each_line do | line |

      m = /# Ditto (?<action>hold|delete) on (?<environment>[a-zA-Z]+)[\s*]:[\s*](?<lines>\d+)/.match(line)

      if m 
        actions[:action] = m[:action].to_sym
        actions[:env] = m[:environment]
        actions[:lines] = m[:lines].to_i

        dittos += actions[:lines]
      else

        if actions[:lines].nil?
          out_file.puts(line)
        else
          
          if actions[:lines] == 0

            out_file.puts(line)

          elsif (actions[:action] == :hold and actions[:env] == @env) or (actions[:action] == :delete and actions[:env] != @env)

            out_file.puts(line)
            actions[:lines] -= 1;

          else

            actions[:lines] -= 1;

          end

        end
      end

    end

    out_file.close
    puts "#{dittos} lines ditted!"
  end

end