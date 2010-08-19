# The Music of Life

This little toy project is a simple Ruby implementation of Conway's Game of Life.

But then something occurred to me: The output looks a look like a music sequencer.
What if the output of the Game of Life could be used to create generative music?
Surely I'm not the first to come up with such an idea, but with today being
August 19th, aka [Whyday](http://whyday.org/), I decided to try it out.

The first file, field.rb, is the playing field. It is an object representing the
grid of our game, and contains methods for determining neighbors and performing
the population/depopulation of individual cells.

The second file, life.rb, is an implementation of Conway's Game of Life, printing
the output to stdout, clearing the screen between evolutions for a real basic
animation.

The third file is where the magic happens.

I map the cells in each row of the playing field to notes in the Pentatonic Scale.
Why Pentatonic? It's mainly because playing pretty much any note in that scale at
a time sounds good.

Then once I iterate over all the rows, each row being a single beat, I send that
data to the MIDI synth using Ben Bleything's [midiator](http://github.com/bleything/midiator) gem.

## Installation

    gem install midiator
    git clone git@github.com:bratta/life_music.git
    cd life_music
    ruby life_music.rb
    
To make things more interesting, open up life_music.rb and fiddle with the settings,
such as @initial_cells, the @duration of each note, and @midi.program_change to 
change the instrument used. If you change the size of the playing field, be sure
to change the number of notes in the @notes array to match.

I'm also explicitly setting the synth driver used by midiator to :dls_synth, with:

    @midi.use :dls_synth
    
If you're not on OS X you might want to change that to the driver provided for 
your platform, or set it to auto detect. I had issues with auto detection hence 
the reason for it being set manually.
