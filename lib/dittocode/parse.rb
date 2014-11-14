require 'pry'

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
      file = File.open(file_path, "r")
      if isView 
        @file_name = File.basename(file_path, ".erb") 
      else
        @file_name = File.basename(file_path, ".rb")
      end
      @dir_name = File.dirname(file_path) + "/"
      @isView = isView
      @first_line = true

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
              # is catch a block of DittoCode::Exec.is (Inline conditionals)
              is =  /[\s]*(?<action>if|unless)[\s]+DittoCode::Exec.is[\s]+['|"](?<environment>[a-zA-Z,]+)['|"][\s]*/.match(line)
              # m catch a block of dittoCode::Exec.if (Block conditionals)
              m =   /[\s]*<%[\s]*DittoCode::Exec.if[\s]+['|"](?<environment>[a-zA-Z,]+)['|"][\s]+do[\s]*%>/.match(line)
            else
              rem = /[\s]*DittoCode::(?<action>Remove|Hold)File.if[\s]+['|"](?<environment>[a-zA-Z,]+)['|"][\s]*/.match(line)
              is =  /[\s]*(?<action>if|unless)[\s]+DittoCode::Exec.is[\s]+['|"](?<environment>[a-zA-Z,]+)['|"]/.match(line)
              m =   /[\s]*DittoCode::Exec.if[\s]+['|"](?<environment>[a-zA-Z,]+)['|"] do/.match(line)
              commented = /^[\s]*#/.match(line)
            end

            # Remove files
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

            # Inline conditionals
            elsif is 

              # Check the action (unless or if)
              if (is[:action] == 'unless' && !DittoCode::Environments.isIncluded?(is[:environment])) || (is[:action] == 'if' && DittoCode::Environments.isIncluded?(is[:environment]))
                # We must hold the line

                # Delete the inline conditional from the line
                line.slice! is[0]

                # Write on the file
                check_with_indent(out_file, line)

              end

            # Commented  
            elsif !@isView && commented

              if !actions[:atack] || DittoCode::Environments.isIncluded?(actions[:env])
                # Write on the file
                check_with_indent(out_file, line)
              end

            # Block conditionals
            elsif m 
              # A block as been detected
              actions[:env] = m[:environment]
              actions[:atack] = true;
              actions[:ends] = 1;
            else

              # Ditto is atacking?
              if !actions[:atack] 
                check_with_indent(out_file, line)
              else 
                # He is transforming
                dittos += 1

                # Check if the line is end
                if isEnd? line

                  # If is the last end, it's coincide with the end of the block
                  if actions[:ends] == 1
                    actions[:atack] = false
                  elsif DittoCode::Environments.isIncluded?(actions[:env])
                    # Only how if we must mantain it
                    check_with_indent(out_file, line)
                  end

                  # -1 end
                  actions[:ends] -= 1

                else

                  # prints of coincide with the environment
                  if DittoCode::Environments.isIncluded?(actions[:env])
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
            dittos += 1
          end

        end

        # Check if the file is removed
        if @removed
          say "[ "+"OK".color("64d67f")+" ] file #{@dir_name}#{@file_name} has been removed"
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

        line.chomp!

        if @first_line

          if @indent
            out_file.print("#{line.indent(-1)}")
          else
            out_file.print("#{line}")
          end

          @first_line = false

        else

          if @indent
            out_file.print("\n#{line.indent(-1)}")
          else
            out_file.print("\n#{line}")
          end

        end
      end 

      # Detect an end line
      def isEnd?(line)

        # Coincide with an end!
        if @isView && /[\s]*<%[\s]*(end)[\s]*%>/.match(line)
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
          initializers = line.scan(/<%[=\s]*(case|unless|if|do|begin)[\s]+/).size 
          initializers += line.scan(/<%[@=;\s\w\d\.\:]{3,}[\s]+(case|do)[\s]+/).size
          initializers += line.scan(/<%[@=;\d\w\s\.\:]{3,}(if|unless)[\s]+[@=;\d\w\s\.\:]+(?:then){1}/).size
          
          finals = line.scan(/[\s]+(end)[\s]*%>/).size
        else
          initializers = line.scan(/^[\s\t]*(case|unless|if|def|do)[\s]+/).size
          initializers += line.scan(/ =[\s\t]*(case|unless|if)[\s]+/).size
          initializers += line.scan(/^[\s\t]*(begin)[\s]*/).size               # If, def, unless... of a start line
          initializers += line.scan(/[\s\t]+(case|do)[\s]+[|]+/).size                               # Case or do inside a line
          initializers += line.scan(/[\s\t]+(do)[\s]*$/).size                                       # Finals do
          initializers += line.scan(/[\s\t]+(if|unless)[\s]+[@=;\d\w\s\.\:]+(?:then){1}/).size           # Only if|unless + then, this line disable error by: unless|if var

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
        file.close

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