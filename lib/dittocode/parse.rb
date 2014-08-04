module DittoCode
  class Parse

    # Require
    require 'indentation'

  	# Say hello ditto
    def self.hi
      say "Hi man! What's up?"
    end

    # Initialize the environment
    def initialize(environment, override)
      @env = environment;
      @override = override;
    end

    # Transform the file based in the environment
    def transformation(file_path, @isView)

      # Start to read the file
      file = File.open(file_path)
      @file_name = File.basename(file_path, ".rb") 
      @dir_name = File.dirname(file_path) + "/"

      # Generate the new archive
      out_file = initiateFile(file_path)

      dittos = 0;
      actions = { atack: false }

      # Get the text
      # Protect against nil or directory when it's a file
      begin
        text = file.read

        # Each line........
        text.each_line do | line |

          if @isView
            m = /[\s]*<%[\s]*DittoCode::Exec.if[\s]+['|"](?<environment>[a-zA-Z]+)['|"][\s]+do[\s]*%>/.match(line)
          else
            m = /[\s]*DittoCode::Exec.if[\s]+['|"](?<environment>[a-zA-Z]+)['|"] do/.match(line)
          end

          if m 
            actions[:env] = m[:environment]
            actions[:atack] = true;
            actions[:ends] = 1;
          else

            if !actions[:atack] 
              out_file.puts(line)
            else 
              # He is transforming
              dittos += 1

              # Check if the line is end
              if isEnd? line

                # If is the last end, it's coincide with the end of the block
                if actions[:ends] == 1
                  actions[:atack] = false
                elsif actions[:env] == @env
                  # Only how if we must mantain it
                  out_file.puts(line.indent(-1))
                end

                actions[:ends] -= 1

              else

                # prints of coincide with the environment
                if actions[:env] == @env
                  out_file.puts(line.indent(-1))
                end

                # Check if we need to add a new end
                new_ends = moreEnds? line
                actions[:ends] += new_ends
                dittos += new_ends
              end

            end

          end

        end

        say "[Ok] #{dittos} lines ditted on #{@dir_name}#{@file_name}!"
        closeFile(out_file)
      
      rescue => e

        if e.class == Errno::EISDIR
          say "[Err] If you wants to use a directory use the option -f"
        else 
          say "[Err] Oh no! I have an error :("  
        end

      end 
    end

    private

      # Detect an end line
      def isEnd?(line)

        # Coincide with an end!
        if /^[\s]*end/.match(line)
          return true
        end

        return false
      end

      # Detect if we need to add a new end
      def moreEnds?(line)

        # Get the initializers and the ends of the blocks
        if @isView
          initializers = line.scan(/<%[\s]*(if|do|def)[\s]+/).size + line.scan(/<%[@=;\s\w\d]*(if|do|def)[\s]+/).size
          finals = line.scan(/[\s]+(end)[\s]*%>/).size + line.scan(/<%[\s]*(end)[\s]*%>/).size
        else
          initializers = line.scan(/^(if|do|def)[\s]+/).size + line.scan(/[\s]+(if|do|def)[\s]+/).size + line.scan(/[\s]+(if|do|def)$/).size
          finals = line.scan(/[\s]+(end)[\s]+/).size + line.scan(/^(end)[\s]+/).size + line.scan(/[\s]+(end)$/).size
        end

        # Return the difference
        initializers - finals

      end

      # Open the file
      def initiateFile(file_path)

        if(@override)
          File.new("#{@dir_name}#{@file_name}_tmp.rb", "w")
        else
          File.new("#{@dir_name}#{@file_name}_#{@env}.rb", "w")
        end

      end

      # Close the file
      #
      # file        => file to close
      # file_name   => name of the file
      # file_path   => path of the original file
      def closeFile(file)

        # Close the file
        file.close;

        if(@override)
          File.delete(file)
          File.rename(file, "#{@dir_name}#{@file_name}.rb")
        end

      end
  end

end