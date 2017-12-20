require 'pry'

class BoardAnalizer
  DELETED_VALUE = 5
  attr_reader :map_cells, :groups

  def initialize(size, cells)
    @size = size
    @cells = cells
    @map_cells = Array.new(5, Array.new(5,0))
    @groups = []
  end

  def analyze
    @cells.each.with_index do |row, row_index|
      row.each.with_index do |element, element_index|
        next unless @map_cells[row_index][element_index].zero?
        next if element == DELETED_VALUE
        @groups << build_group(element, row_index, element_index)
      end
    end
  end

  protected

  def build_group(element, row_index, element_index)
    current_group = [[row_index, element_index]]
    return_to = {}

    cur_i = row_index
    cur_j = element_index
    element_number = 0

    while true do
      binding.pry
      neib = good_neiborghouds(element, cur_i, cur_j)
      cur_i, cur_j = return_to.delete([cur_i, cur_j]) if neib.empty?
      current_group.concat(neib)
      current_group.each { |i, j| @map_cells[i][j] = 1 } if current_group.count > 1

      element_number += 1
      break if element_number >= current_group.size
      return_to[current_group[element_number]] = [cur_i, cur_j]
      cur_i, cur_j = current_group[element_number]
    end

    current_group
  end

  def good_neiborghouds(element, cur_i, cur_j)
    neiborghouds(cur_i, cur_j).reject do |i,j|
      @cells[i][j] == DELETED_VALUE || @map_cells[i][j] > 0 ||
        @cells[i][j] != element
    end
  end

  def neiborghouds(cur_i, cur_j)
    [
      [cur_i-1, cur_j],
      [cur_i+1, cur_j],
      [cur_i, cur_j-1],
      [cur_i, cur_j+1]
    ].reject { |ar| ar.include?(-1) || ar.include?(@size) }
  end
end
