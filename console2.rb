require 'io/console'
# rows, columns = $stdout.winsize
# puts "Your screen is #{columns} wide and #{rows} tall"
input = ''
print "\e[2J"

run = true
command = ''
while run
  print "\e[10;0H\e[Kinput: #{input}\e[H"
  char = STDIN.getch
  if char == ':'
    print "\e[11;0H\e[K:"
    do_command = true
    while do_command
      command_c = STDIN.getch
      case command_c.chr
      when "\r"
        case command
        when "q"
          run = false
          print "\e[11;0H\e[K"
        else
          print "\e[11;0H\e[KUnknown Command: #{command}"
        end
        do_command = false
      when "\e"
        do_command = false
        print "\e[11;0H\e[K\e[H"
        command = ''
      when "\u007F"
        command = command.chars.reverse.drop(1).reverse.join
        print "\e[11;0H\e[K:#{command}"
      else
        command << command_c
        print "\e[11;0H\e[K:#{command}"
      end
    end
  else
    input << char.chr.bytes.to_s
  end
end
