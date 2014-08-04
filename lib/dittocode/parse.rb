module DittoCode
  class Parse

    # Require
    require 'indentation'

  	# Say hello ditto
    def self.hi
      say "Hi man! What's up?"
    end

    # Initialize the environment
    def initialize(environment, override, verbose, indent)
      @env = environment
      @override = override
      @verbose = verbose
      @indent = indent
    end

    # Transform the file based in the environment
    def transformation(file_path, isView)

      # Start to read the file
      file = File.open(file_path)
      if isView 
        @file_name = File.basename(file_path, ".erb") 
      else
        @file_name = File.basename(file_path, ".rb")
      end
      @dir_name = File.dirname(file_path) + "/"
      @isView = isView

      # Generate the new archive
      out_file = initiateFile(file_path)

      dittos = 0;
      actions = { atack: false }

      # Get the text
      # Protect against nil or directory when it's a file
      begin
        # Each line........
        file.each_line do | line |

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
              if file.eof?
                # Don't print a \n in the last line
                out_file.print(line)
              else  
                out_file.puts(line)
              end

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
                  check_with_indent(out_file, line)
                end

                actions[:ends] -= 1

              else

                # prints of coincide with the environment
                if actions[:env] == @env
                  check_with_indent(out_file, line)
                end

                # Check if we need to add a new end
                new_ends = moreEnds? line
                actions[:ends] += new_ends
                dittos += new_ends
              end

            end

          end

        end

        if @verbose || dittos != 0
          say "[Ok] #{dittos} lines ditted on #{@dir_name}#{@file_name}!"
        end

        closeFile(out_file)
      
      rescue => e

        if e.class == Errno::EISDIR
          say "[Err] If you wants to use a directory use the option -f"
        else 
          say "[Err] Oh no! I have an error :("  
        end

        if @verbose
          say e
        end

      end 
    end

    private

      # Send the line into the file. If indent is true
      # The line will be indented
      def check_with_indent(file, line)
        if @indent
          out_file.puts(line.indent(-1))
        else
          out_file.puts(line)
        end
      end 

      # Detect an end line
      def isEnd?(line)

        # Coincide with an end!
        if @isView && /[\s]+(end)[\s]*%>/.match(line)
          true
        elsif /^[\s]*end/.match(line)
          true
        else
          false 
        end
      end

      # Detect if we need to add a new end
      def moreEnds?(line)

        # Get the initializers and the ends of the blocks
        if @isView
          initializers = line.scan(/<%[\s]*(if|do|def)[\s]+/).size + line.scan(/<%[@=;\s\w\d]*(if|do|def)[\s]+/).size
          finals = line.scan(/[\s]+(end)[\s]*%>/).size
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
          if @isView 
            File.new("#{@dir_name}#{@file_name}_tmp.erb", "w")
          else
            File.new("#{@dir_name}#{@file_name}_tmp.rb", "w")
          end
        else
          if @isView 
            File.new("#{@dir_name}#{@file_name}_#{@env}.erb", "w")
          else
            File.new("#{@dir_name}#{@file_name}_#{@env}.rb", "w")
          end
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
          if @isView 
            File.delete("#{@dir_name}#{@file_name}.erb")
            File.rename(file, "#{@dir_name}#{@file_name}.erb")
          else
            File.delete("#{@dir_name}#{@file_name}.rb")
            File.rename(file, "#{@dir_name}#{@file_name}.rb")
          end
        end

      end
  end

end