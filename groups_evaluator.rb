class GroupsEvaluator
  def initialize(size, board, board_map, groups)
    @size = size
    @board = board
    @board_map = board_map
    @groups = groups.reject { |group| group.size < 2 }
    @best_group = []
    @half_best_group = []
    @smallest_groups = groups.select { |group| group.size < 2 }
  end

  def best_group
    split_groups
    @best_group.first || @half_best_group.first
  end

  private

  def split_groups
    @groups.each do |group|
      if have_near_alone_element?(group)
        @best_group << group
      else
        @half_best_group << group
      end
    end
  end

  def have_near_alone_element?(group)
    group_width = group.uniq { |pos| pos.last }.sort { |pos| pos.last }
    element = @board[group.first.first][group.first.last]
    group_width << [group_width.last.first, group_width.last.last + 1] if group_width.last.last < @size - 1
    group_width << [group_width.first.first, group_width.first.last - 1] if group_width.first.last > 0

    group_width.map do |i,j|
      go_down = i.upto(@size-1) do |row|
        cur_el = @board[row][j]
        if cur_el == element
          next if group.include?([row,j])
          break true if @board_map[row][j] > 0
          break false if @board_map[row][j].zero?
        end
      end

      if go_down
        i.downto(0) do |row|
          cur_el = @board[row][j]
          if cur_el == element
            next if group.include?([row,j])
            break true if @board_map[row][j] > 0
            break false if @board_map[row][j].zero?
          end
        end
      end
    end.all? { |e| e }
  end
end
