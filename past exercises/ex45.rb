# Lay out the rooms

# Lay out the states
# Win and Die

# Lay out the action
# Move to a new room

# I could have also required all the separate classes instead of being one big file, like
=begin
ex45.rb
require './basement.rb'
require './dress.rb'
require './necklace.rb'
require './merman.rb'
require './players.rb'
require './zombie.rb'
require './ending.rb'
require './enginemap.rb'

game_map = Map.new('basement')
game_engine = Engine.new(game_map)
game_engine.play()
=end


# 1. Create a map of the house with the rooms
system('clear')

# Good practice to Class the room action then subclass it.

class Room
    def enter()
        puts "This will never be called"
        exit(1)
    end
end

class Engine

    def initialize(room_map)
        @room_map = room_map
    end

    # This decides how the game flows through the map based on user action
    def play()
        # current room is set to the opening room of the map, lobby
        current_room = @room_map.opening_room()

        last_room = @room_map.next_room('finished')

        while current_room != last_room
            next_room_name = current_room.enter()
            current_room = @room_map.next_room(next_room_name)
        end

        current_room.enter() #I don't think I need this
    end

end

class Death < Room
    @@finished_notes = [
        "What a way to go!",
        "Ooooh, who saw that coming!",
        "Are we having fun yet?",
        "Try again, it's ok, we all stumble",
        "Ok, I give up.",
        "Death Line to be written soon"
    ]

    def enter()
        puts @@finished_notes[rand(0..(@@finished_notes.length-1))]
        exit(0)
    end
end

class Lobby < Room
    def enter()
        puts "You enter the lobby of the haunted house."
        puts "There is a kitchen in front of you, the dining room to the left, and the bedroom to the right."
        puts "The door slams shut behind you! You hear a noise above you, it's the chandelier. It's swinging back and forth, the cord making a strained sound."
        puts "CRACK! The chandelier cord breaks, hurling it down to you. Quick! Jump into a room: "
        # An array for room choices, makes it expandable if I want to add more
        room_choice = ['The Kitchen', 'The Dining Room', 'The Bedroom']
        # Now, numerate and display
        (1..room_choice.length).each do |number|
            puts "#{number}. %s" % room_choice[number-1]
        end

        print "You choose number: "

        room = gets.chomp

        if room == "1"
            return 'kitchen'
        elsif room == "2"
            return 'bedroom'
        elsif room == "3"
            return 'dining_room'
        else 
            puts "The chandelier falls on you. You're dead :("
            return 'death'
        end
    end
end

class Kitchen < Room
    def enter()
    puts "You are in the kitchen"
    puts "You see the chandelier behind the stove"
    puts "There is a knife, a rolling pin, and a glass of water"
    puts "What do you throw at the chandelier"
    print "Knife, rolling pin, or water: "

    throw = $stdin.gets.chomp.downcase

        if throw == "knife"
            puts "You throw the knife, but the chandelier dodges it"
            puts "It runs at you, screaming its chandelier head off"
            puts "You try to dodge it, but it's too late"
            puts "You're dead meat"
            return 'death'
        elsif throw == "rolling pin"
            puts "You threw a rolling pin at the chandelier"
            puts "What did you think it was going to do?"
            return 'death'
        elsif throw == "water"
            puts "You threw water on the chandelier"
            puts "It screams in agony"
            puts "Oh, the misery"
            puts "Quick, while its distracted, run away"
            puts "You run outside and never come back to the haunted house. Why didn't you think of that earlier?"
            return 'finished'
        else
            puts "Too late, you didn't make a choice"
            return 'death'
        end
    end
end

class DiningRoom < Room
    def enter()
    puts "Ah, the dining room."
    puts "This is where it ends, you and the chandelier"
    puts "The chandelier sits at one end of the table, you at the other."
    puts "You decide to play a game. Roll the dice, make a guess."
    puts "If you guess the correct number, you can kill the chandelier once and for all and leave the house."
    puts "But if you don't guess the correct number, the chandelier will finally have its way with you. Whatever that means to a chandelier."
    puts "The die is cast. What number do you guess? "
    print "> "
    guess = $stdin.gets.chomp.to_i

    die = rand(1..6)
        if guess == die
            puts "Wow, you won!"
            puts "The chandelier looks up, tears in its eyes."
            puts "You feel sad for a moment."
            puts "You two stare at each other, holding it until glass shards explode from the chandelier's head."
            puts "Of course you weren't going to soften up now"
            return 'finished'
        else
            puts "You and the chandelier stare at each other."
            puts "You reach for your gun, but the glass shard in your eye makes you pause for a moment."
            puts "So this is what it feels like?"
            return 'death'
        end
    end
end

class Bedroom < Room
    def enter()
    puts "You are in the bedroom"
    puts "You see a safe in the side door. You decide to crack it"
    puts "The safe has a three digit code"
    puts "You have five guesses, then the safe shuts forever"
    puts "What three numbers do you guess? "
    puts "[CODE]..."

    code = "#{rand(1..5)}#{rand(1..5)}#{rand(1..5)}"

    guess = $stdin.gets.chomp
    guesses = 1

    while guesses < 5 || guess == code
        puts "BZZZ Incorrect"
        guesses += 1
        puts "[CODE]..."
        guess = $stdin.gets.chomp
    end

    if guess == code
        puts "You cracked it!"
        puts "You see a note inside, it says..."
        puts "HAHAHAHAHA"
        puts "You look up. The chandelier is behind you."
        puts "It stabs you in the back"
        return 'death'

    else
        puts "You didn't crack the code"
        puts "As expected, nothing happens"
        puts "You decide to go to one of the other rooms"
        puts "Kitchen or Dining Room?"

        room = $stdin.gets.chomp

            if room == 'kitchen'
                    return 'kitchen'
            elsif room == 'dining_room'
                    return 'dining_room'
            else
                puts "Please make a choice"
            end
        end
    end
end


class Finished < Room
        @@finished_notes = [
            "Hey, you did it!",
            "Nice! Who would have thought?",
            "That was easy",
            "Why didn't I think of that"
        ]
    
        def enter()
            puts @@finished_notes[rand(0..(@@finished_notes.length-1))]
            exit(0)
        end
    
end

# Defines the map and rooms of the house
class Map
    
    @@rooms = {
        'lobby' => Lobby.new(),
        'kitchen' => Kitchen.new(),
        'dining_room' => DiningRoom.new(),
        'bedroom' => Bedroom.new(),
        'death' => Death.new(),
        'finished' => Finished.new(),
    }

    # Initialize the map with a starting room argument
    # When I create a map, start with a room
    # Don't have attr_accessors, since nothing to read/write
    # def initialize is a ruby constructor
    def initialize(start_room)
        @start_room = start_room
    end

    # How to decide what the next room is. Provide the name of the room, then find the room in hash table
    def next_room(next_room)
        return @@rooms[next_room]
    end

    # define an opening room, which is returning the name of the start room.
    # Why do I need an opening room, doesn't initialize do that?
    # I don't think so, because I can't call initialize in another method
    def opening_room()
        return next_room(@start_room)
    end
end

# Create a new Map object using lobby as start_room (lobby is an object of the Map class)
lobby = Map.new('lobby')
room_map = Engine.new(lobby)
room_map.play()