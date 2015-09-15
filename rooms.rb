###################################
#######  GAME OF ROOMS     ########
###################################

# The objective of 'game of rooms' is to navigate
# all the rooms of a house by typing directions.
# The game is finished when the player finds all
# the hidden objects or dies by accident.

DIRECTIONS = ["N", "E", "S", "W"]
COMMANDS = ["QUIT", "SEARCH", "PICK UP", "DROP", "INVENTORY", "WHERE", "COUNT", "HELP"]

class Scene
  
  def initialize(name, description, exits, commands, objects)
    @name = name
    @description = description
    @exits = exits
    @commands = ["QUIT", "INVENTORY", "WHERE", "COUNT", "HELP"] << commands
    @objects = objects
  end  
  
  def enter
    puts """  
    #{@name.upcase}
    ************************
            
    #{@description}.""" 
    puts "Object(s) in the room: #{@objects.join(' and ')}." unless @objects == []
    puts           
    puts "Possible exits:  #{@exits.keys.join(' or ')}\n\n" unless @exits == {} 
    print '>>> '
    action = $stdin.gets.chomp.upcase
    if @exits.has_key?(action)
      #system("clear")
      [ 'dir', @exits[action] ]
    elsif @commands.include?(action)
      puts "Your command truly is a command!"
      #system("clear")
      [ 'com', action ]
    else 
      if is_direction?(action)
        #system("clear")
        puts 'You cannot go that way! Please try again.'
        puts '==========================================='
      elsif is_command?(action) 
        #system("clear")        
        puts 'You cannot do that in this room!' 
        puts '==========================================='
      else 
        #system("clear")
        puts 'I do not understand what you are saying'
        puts '==========================================='
      end
      self.enter  
    end
  end
    
  def is_direction?(action)
    DIRECTIONS.include?(action)
  end
    
  def is_command?(action)
    COMMANDS.include?(action)
  end
  
end

def play(scenes)  
  system("clear")
  opening_scene = :outside
#  closing_scene = :end
  next_scene = scenes[opening_scene].enter
  
  ### FIXME: there is as yet no end to the game
  while next_scene
    action = scenes[next_scene[1].to_sym].enter
    if action[0] == 'dir'
      next_scene = action
    elsif action[0] == 'com'
      do_command(action[1])
    end
  end
  
  #closing_scene.enter
end

def do_command(command)
  case command
    when 'QUIT'
      puts "I am sorry to see you go. \n"
      gets.chomp
      exit(1)
    when 'INVENTORY'
      
    else 
      puts "You ask me to do #{command}. As yet I do not know what to do with that"
    end
end

outside = Scene.new(
  'outside',
  """ Welcome to the game of MY NEIGHBOUR'S HOUSE! The object of the game is to
  visit ALL the rooms and to find all the hidden objects by using the command 
  'search'. If you do not find all the objects within 20 moves, your neighbours 
  will return and shoot you as the burglar you are. 
  
  You are outside in front of a large house. The door is open. """,
  { 'N' => 'entrance' },
  [],
  []
)

entrance = Scene.new( 
  'entrance', 
  'You are in the entrance. You can go N or S', 
  { 'N' => 'kitchen', 
    'S' => 'outside' },
  [],  
  []
)

kitchen = Scene.new(
  'kitchen',
  'You are in the kitchen. You can go all directions',
  { 'N' => 'living_room',
    'E' => 'office', 
    'S' => 'entrance',
    'W' => 'bath_room' },
    [],
    ['a knife', 'a table']
)

store_room = Scene.new(
  'store_room',
  'You are in a dark storeroom. There is no way out',
  { 'N' => 'office' },
  [],
  []
)

office = Scene.new(
  'office',
  'You are in an office. There is a room S',
  { 'S' => 'store_room', 
    'W' => 'kitchen' },
  [],
  []
)

living_room = Scene.new(
  'living_room',
  'You are in a living room. You can go W',
  { 'S' => 'kitchen', 
    'W' => 'bed_room' },
  [],
  []
)

bath_room = Scene.new(
  'bathroom',
  'You are in a bath room. You can go N and back',
  { 'N' => 'bed_room', 
    'E' => 'kitchen' },
  [],
  []
)    

bed_room = Scene.new(
  'bedroom',
  'You are in a bedroom with an exit to the living room',
  { 'E' => 'living_room',
    'S' => 'bath_room' },
  [],
  []
)

scenes = {  :start => start,
            :outside => outside, 
            :entrance => entrance, 
            :kitchen => kitchen, 
            :store_room => store_room, 
            :office => office, 
            :living_room => living_room, 
            :bath_room => bath_room, 
            :bed_room => bed_room }

play(scenes)


  
