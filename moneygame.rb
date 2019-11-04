require 'gosu'

class Moneygame < Gosu::Window
    def initialize
        super 800, 600
        self.caption = "Money Game"

        @background_image = Gosu::Image.new("padjen.jpg", :tileable => true)

        @player = Player.new
        @player.warp(320, 600)

        @money = Array.new
        @font = Gosu::Font.new(20)
        @bill = Bill.new
        @bill.warp(rand, 0)

    end

    def update
        
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
            @player.move_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
            @player.move_right
        end
        
        @player.collect_money(@money)
        @player.teleport

        if rand(15) < 0.025
            @money.push(Bill.new)
        end 
    end
    def draw
        @background_image.draw(0,0,ZOrder::BACKGROUND)
        @money.each { |bill| bill.draw}
        @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1, 1, Gosu::Color::YELLOW)
        @player.draw
    end
end

class Player
    attr_reader :score

    def initialize
        @image = Gosu::Image.new("gaben.png")
        @x = @y = 0
        @score = 0
    end

    def warp(x,y)
        @x, @y = x, y
    end
    def move_right
        @x += 5
    end
    def move_left
        @x -= 5
    end
    def teleport
        @x %= 800

    end

    def draw
        img = @image
        @image.draw(@x - img.width, @y - img.height, 1)
    end
    def score
        @score
    end
    def collect_money(money)
        money.reject! do |bill|
            if Gosu.distance(@x-61.5, @y-61.5, bill.x, bill.y) < 50
                @score += 10
                true
            elsif bill.y == 600
                true
            else
                false
            end
        end
    end
end

class Bill
    attr_reader :x, :y

    def initialize
        @image = Gosu::Image.new("money.jpg")
        @x = rand * 800
        @y = 0
    end
    def warp(x,y)
        @x = x
        @y = y
    end

    def draw
        img = @image
        @image.draw(@x - img.width / 2.0, @y - img.height / 2.0, ZOrder::MONEY)
        @y += 2
    end  
end

module ZOrder
    BACKGROUND, MONEY, PLAYER, UI = * 0..3
end

Moneygame.new.show
