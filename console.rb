require 'io/console'

command = ''
command_mode_char = ''
command_mode_action = nil
COMMAND_MODE = :command_mode
INSERT_MODE = :insert_mode
CONSOLE_MODE = :console_mode

current_mode = COMMAND_MODE

run = true

print "\033[2J" # clear the screen
winsize_rows, _winsize_cols = STDIN.winsize

command_line_row = winsize_rows
editor_window_rows = command_line_row
# editor_window_rows.times do |l|
#   print "\033[#{l};0H" # command_mode_action position
#   print "#{l}: "
# end
print "\033[H"

while run
  char = STDIN.getch
  if char == ':'
    print "\e[#{command_line_row};0H\e[K:"
    do_command = true
    while do_command
      command_c = STDIN.getch
      case command_c.chr
      when "\r"
        case command
        when "q"
          run = false
          print "\e[H"
          winsize_rows.times { |l| print "\e[#{l};0H\e[K" }
          print "\e[#{winsize_rows};0H"
        else
          print "\e[#{command_line_row};0H\e[KUnknown Command: #{command}"
        end
        do_command = false
      when "\e"
        do_command = false
        print "\e[#{command_line_row};0H\e[K\e[H"
        command = ''
      when "\u007F"
        command = command.chars.reverse.drop(1).reverse.join
        print "\e[#{command_line_row};0H\e[K:#{command}"
      else
        command << command_c
        print "\e[#{command_line_row};0H\e[K:#{command}"
      end
    end
  else
    case char
    when "\e"
      command_mode_char = ''
    else
      command_mode_char << char
      case command_mode_char
      when 'h'
        command_mode_action = "\e[1D"
      when 'j'
        command_mode_action = "\e[1B"
      when 'k'
        command_mode_action = "\e[1A"
      when 'l'
        command_mode_action = "\e[1C"
      when 'gg'
        command_mode_action = "\e[0;0H"
      when 'G'
        command_mode_action = "\e[9;0H"
      when 'i'
        command_mode_char = ''
        do_insert = true
        while do_insert
          insert_c = STDIN.getch
          case insert_c
          when "\e"
            do_insert = false
          when "\r"
            print "\n\r"
          else
            print insert_c
          end
        end
      end
      unless command_mode_action.nil?
        print command_mode_action
        command_mode_char = ''
        command_mode_action = nil
      end
    end
  end
end
