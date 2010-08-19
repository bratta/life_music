class WrappedArray < Array
  def [](index)
    super(index % length)
  end
  
  def self.mda(width,height,value=nil)
    a = WrappedArray.new(width)
    a.map!{ WrappedArray.new(height, value) }
    return a
  end
end


class Field
  attr_accessor :playing_field, :grid_size, :initial_elements, :neighbor_cells
  
  def initialize(grid_size=10, initial_elements=10)
    @grid_size = grid_size
    @initial_elements = initial_elements
    @playing_field = WrappedArray.mda(@grid_size, @grid_size, 0)
    @neighbor_cells = [[1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1], [1,-1]]
    randomize_field
  end
  
  def randomize_field
    @initial_elements.times do
      x = rand(@grid_size)
      y = rand(@grid_size)
      populate(x,y)
    end
  end
  
  def print_field
    @playing_field.each do |row|
      formatted_row = row.map {|x| (x==1) ? '#' : ' '}
      print formatted_row.join(' ')
      print "\n"
    end
    print "\n"
  end
  
  def populate(x,y)
    @playing_field[x][y] = 1
  end
  
  def populated?(x,y)
    @playing_field[x][y] == 1
  end
  
  def depopulate(x,y)
    @playing_field[x][y] = 0
  end
  
  def neighbor_count(x,y)
    @neighbor_cells.count { |dx,dy| populated?(x+dx, y+dy)}
  end
end