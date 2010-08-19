#!/usr/bin/env ruby

require 'field'

# Rules of the Game of Life
# Any live cell with < 2 neighbors dies (underpopulation)
# Any live cell with > 3 neighbors dies (overpopulation)
# Any live cell with 2-3 neighbors lives (statis)
# Any dead cell with exactly 3 neighbors becomes a live cell (reproduction)

class Life
  attr_accessor :grid_size, :initial_cells, :evolutions, :field
  
  def initialize
    # Default grid size. The grid must be square and will initialize a
    # playing field of #{grid_size} elements, each element an array
    # of #{grid_size} elements
    @grid_size = 40

    # Random number of cells to start with
    @initial_cells = 200

    # Number of times to play
    @evolutions = 50
    
    # Create our playing field
    @field = Field.new(grid_size, initial_cells)
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

  def play
    show_field(0)
    evolutions.times do |evo|
      @grid_size.times do |x|
        @grid_size.times do |y|      
          check_underpopulation(x,y)
          check_overpopulation(x,y)
          reproduce(x,y)
        end
      end
      show_field(evo)
    end
  end
  
  def show_field(evolution_number)
    puts "\e[H\e[2J"    
    @field.print_field
    print "Evolution: #{evolution_number}\n\n"
    sleep 0.25
  end
end

life = Life.new
life.play