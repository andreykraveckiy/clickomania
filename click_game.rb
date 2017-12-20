$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require "httparty"
require "yaml"
require "board_analizer"
require "groups_evaluator"

module ClickGame
  TOKEN = "OAGXJMOJQQMVDRBP"
  extend self

  def run
    # response = HTTParty.get("https://clickomania.anadea.info/game?size=5&token=#{TOKEN}")
    # cells = YAML.load(response["cells"]).transpose
    # size = response["width"].to_i
    cells = [[4, 1, 1, 4, 0], [0, 2, 3, 4, 2], [4, 4, 3, 4, 2], [4, 0, 4, 3, 1], [0, 2, 3, 0, 1]]
    size = 5
    tour = BoardAnalizer.new(size, cells)
    tour.analyze
    p cells
    p tour.map_cells
    p tour.groups

    delete_group = GroupsEvaluator.new(size, cells, tour.map_cells, tour.groups)
    group = delete_group.best_group
    p group
  end
end

ClickGame.run
