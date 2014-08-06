module DittoCode
  class Parse

    # Require
    require 'indentation'
    require 'rainbow'
    require 'rainbow/ext/string'

    # Initialize the environment
    def initialize(override, verbose, indent)
      @env = ENV["DITTOCODE_ENV"]
      @override = override
      @verbose = verbose
      @indent = indent
    end

    # Transform the file based in the environment
    def transformation(file_path, isView)

      # Init removed false
      @removed = false

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

          # Ignore the line require ditto_code to delete it on final releases
          if /[\s]*require[\s]*['|"](ditto_code)['|"]/.match(line).nil?

            if @isView
              # rem can stop the execution of this file
              rem = /[\s]*<%[\s]*DittoCode::(?<action>Remove|Hold)File.if[\s]+['|"](?<environment>[a-zA-Z,]+)['|"][\s]*%>/.match(line)
              # m catch a block of dittoCode::Exec
              m = /[\s]*<%[\s]*DittoCode::Exec.if[\s]+['|"](?<environment>[a-zA-Z,]+)['|"][\s]+do[\s]*%>/.match(line)
            else
              rem = /[\s]*DittoCode::(?<action>Remove|Hold)File.if[\s]+['|"](?<environment>[a-zA-Z,]+)['|"][\s]*/.match(line)
              m = /[\s]*DittoCode::Exec.if[\s]+['|"](?<environment>[a-zA-Z,]+)['|"] do/.match(line)
            end

            if rem

              # Remove the files and stop the execution of this script
              if rem[:action] == 'Remove'
                # Remove action
                if DittoCode::Environments.isIncluded? rem[:environment]
                  @removed = true
                  break
                end

              else

                # Hold action
                unless DittoCode::Environments.isIncluded? rem[:environment]
                  @removed = true
                  break
                end
                
              end

              dittos += 1

            elsif m 
              # A block as been detected
              actions[:env] = m[:environment]
              actions[:atack] = true;
              actions[:ends] = 1;
            else

              # Ditto is atacking?
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

                  # -1 end
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

          else
            # We delete the line require 'ditto_code'
            dittos += 1
          end

        end

        # Check if the file is removed
        if @removed
          say "[ "+"OK".color("64d67f")+" ] file #{@dir_name}#{@file_name} as been removed"
        elsif @verbose || dittos != 0
          printf("Ditto say -> [ "+"OK".color("64d67f")+" ] %5s lines ditted on #{@dir_name}#{@file_name}\n", dittos)
        end

        # Close and save the file
        closeAndSaveFile(out_file)
      
      rescue => e

        if e.class == Errno::EISDIR
          say "[ "+"ERR".color("ed5757")+" ] If you wants to use a directory use the option -f"
        else 
          say "[ "+"ERR".color("ed5757")+" ] Oh no! I have an error :("  
        end

        if @verbose
          say e
        end

      end 
    end

    private

      # Send the line into the file. If indent is true
      # The line will be indented
      def check_with_indent(out_file, line)
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
          initializers = line.scan(/<%[\s]*(case|unless|if|do|def|begin)[\s]+/).size 
          initializers += line.scan(/<%[@=;\s\w\d]*(case|unless|if|do|def)[\s]+/).size
          
          finals = line.scan(/[\s]+(end)[\s]*%>/).size
        else
          initializers = line.scan(/^[\s\t]*(case|unless|if|do|def|begin)[\s]+/).size               # If, def, unless... of a start line
          initializers += line.scan(/[\s\t]+(case|do)[\s]+[|]+/).size                               # Case or do inside a line
          initializers += line.scan(/[\s\t]+(do)[\s]*$/).size                                       # Finals do
          initializers += line.scan(/[\s\t]+(if|unless)[\s]+[@=\d\w\s]+(?:then){1}/).size           # Only if|unless + then, this line disable error by: unless|if var

          finals = line.scan(/[\s\t]*(end)[\s]*$/).size
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
      def closeAndSaveFile(file)

        # Close the file
        file.close;

        # Check if we must to remove the file
        if @removed 

          # We need to remove
          if @override

            if @isView 
              File.delete("#{@dir_name}#{@file_name}.erb")
            else
              File.delete("#{@dir_name}#{@file_name}.rb")
            end

            File.delete(file)
          else
            File.delete(file)
          end

        elsif @override
          # No delete, but override?
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