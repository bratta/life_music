#!/usr/bin/env ruby

require 'rubygems'
require 'field'
require 'midiator'

# Rules of the Game of Life
# Any live cell with < 2 neighbors dies (underpopulation)
# Any live cell with > 3 neighbors dies (overpopulation)
# Any live cell with 2-3 neighbors lives (statis)
# Any dead cell with exactly 3 neighbors becomes a live cell (reproduction)

class Life
  attr_accessor :grid_size, :initial_cells, :evolutions, :field, :notes, :midi, :duration
  
  include MIDIator::Notes
  
  def initialize
    # Default grid size. The grid must be square and will initialize a
    # playing field of #{grid_size} elements, each element an array
    # of #{grid_size} elements    
    # NOTE: If you change the grid size, change the @notes array below
    # to match. This way each column will still represent a musical note.
    @grid_size = 10

    # Random number of cells to start with
    @initial_cells = 75

    # Number of times to play
    @evolutions = 50
    
    # Major Pentatonic scale
    @notes = [ C3, D3, E3, G3, A3, C4, D4, E4, G4, A4]
    
    # Create our playing field
    @field = Field.new(grid_size, initial_cells)
    
    # Our sound object
    @midi = MIDIator::Interface.new
    @midi.use :dls_synth
    @midi.instruct_user!
    # http://www.midi.org/techspecs/gm1sound.php
    @midi.program_change 0, 88 # Synth lead (bass + lead)
    
    @duration = 0.25 # Quarter notes
  end

  def check_underpopulation(x,y)
    @field.depopulate(x,y) if @field.populated?(x,y) && @field.neighbor_count(x,y) < 2
  end

  def check_overpopulation(x,y)
    @field.depopulate(x,y) if @field.populated?(x,y) && @field.neighbor_count(x,y) > 3
  end

  def reproduce(x,y)
    @field.populate(x,y) if !@field.populated?(x,y) && @field.neighbor_count(x,y) == 3
  end
  
  def play_music
    song = Array.new
    @field.playing_field.each do |row|
      chord = Array.new
      row.each_with_index do |cell,i|
        chord << notes[i] if cell == 1
      end
      song << chord
    end
    song.each do |note|
      @midi.play note, @duration
    end    
  end

  def play
    evolutions.times do |evo|
      @grid_size.times do |x|
        @grid_size.times do |y|      
          check_underpopulation(x,y)
          check_overpopulation(x,y)
          reproduce(x,y)
        end
      end
      play_music
    end
  end
end

life = Life.new
life.play