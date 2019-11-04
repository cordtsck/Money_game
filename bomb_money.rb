require 'gosu'

class Tutorial < Gosu::Window
    def initialize
      super 640, 480
      @font = Gosu::Font.new(20)
      self.caption = "Money Game"
  
      @background_image = Gosu::Image.new("media2/clouds.png", :tileable => true)
  
      @player = Player.new
      @player.warp(320, 240)

      @bill = Gosu::Image.load_tiles("media2/money.png", 25, 25)
      @bills = Array.new
      @font = Gosu::Font.new(20)

      @coin = Gosu::Image.load_tiles("media2/coin.png", 25, 25)
      @coins = Array.new
      @font = Gosu::Font.new(20)

      @bomb = Gosu::Image.load_tiles("media2/bomb.png", 25, 25)
      @bombs = Array.new
      @font = Gosu::Font.new(20)

      @finish_screen = false


      # 3.times do
      #   @bills.push(Bill.new)
      # end 

      # 5.times do
      #   @coins.push(Coin.new)
      # end

      # 3.times do 
      #   @bombs.push(Bomb.new)
      # end      

    end
  
    def update
      if @player.alive
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
          @player.move_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
          @player.move_right
        end
        
      
        @player.move
        @player.collect_bills(@bills)
        @player.collect_coins(@coins)
        @player.collect_bombs(@bombs)

        if rand(100) < 4 and @bills.size < 25
          @bills.push(Bill.new)
        end
        if rand(30) < 4 and @coins.size < 25
          @coins.push(Coin.new)
        end
        if rand(100) < 4 and @bombs.size < 25
          @bombs.push(Bomb.new)
        end
      else
        if Gosu.button_down? Gosu::KB_SPACE 
          puts "key pressed"
          @player.set_up

        end

      end

    end
  
    def draw
      @player.draw
      #@money.draw
      @coins.each { |coin| coin.draw}
      @bombs.each { |bomb| bomb.draw}
      @bills.each { |bill| bill.draw }
      @font.draw("Player 1: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      @background_image.draw(0, 0, ZOrder::BACKGROUND)

      lose_check
      finish_screen_check

    end
  def finish_screen_check
      if @finish_screen
          @finish_image.draw(200, 50, ZOrder::UI)
          @font.draw("Final Score: #{@player.score}", 500, 600, ZOrder::UI, 2.0, 2.0, Gosu::Color::YELLOW)
      end
  end

  def lose_check
      if @player.alive == false
          @font.draw("You Lose. Press space to restart", 85, 150, ZOrder::UI, 2.0, 2.0, Gosu::Color::YELLOW)
      end
  end
  
    def button_down(id)
      if id == Gosu::KB_ESCAPE
        close
      else
        super
      end
    end
  end
  module ZOrder
    BACKGROUND, BILLS, COINS, BOMBS,PLAYER, UI = *0..6
  end
  class Player
    attr_reader :alive
    def initialize
      @image = Gosu::Image.new("media2/player.png")
      @x = @y = @vel_x = @vel_y = @angle = 0.0
      @score = 0
      @alive = true 
    end
    def set_up
      print "work"
      @score = 0
      @alive = true 
    end 
    def score
      @score
    end
    def collect_bills(bills)
      bills.reject! { |bill| Gosu.distance(@x, @y, bill.x, bill.y) < 35 }
    end
    def collect_coins(coins)
      coins.reject! { |coin| Gosu.distance(@x, @y, coin.x, coin.y) < 45 }
    end
    def collect_bombs(bombs)
      bombs.reject! { |bomb| Gosu.distance(@x, @y, bomb.x, bomb.y) < 45 }
    end
    def warp(x, y)
      @x, @y = x, y
      @y = 410
    end
    
    def move_left
      @x -= 7
    end
    
    def move_right  
      @x += 7
    end

    def move
      @x %= 640
    end
    def draw
      @image.draw_rot(@x, @y, 1, @angle)
    end
    def collect_coins(coins)
      coins.reject! do |coin|
          if Gosu.distance(@x, @y, coin.x, coin.y) < 100
              @score += 50
              
              true
        else
              false
          end
      end
  end

  def collect_bombs(bombs)
    bombs.reject! do |bomb|
        if Gosu.distance(@x, @y, bomb.x, bomb.y) < 100
            @alive = false 
            
            true
      else
            false
        end
    end
end

      def collect_bills(bills)
        bills.reject! do |bill|
            if Gosu.distance(@x, @y, bill.x, bill.y) < 100
                @score += 10
                
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
        @image = Gosu::Image.new("media2/money.png")
        @x = @y = @velocity_x = @velocity_y = @angle = 0.0
        @x = rand * 640
        @y = 0
      end
      

    def update_velocity
        @angle = rand * 360
        @velocity_x += Gosu::offset_x(@angle, 2.5)
        @velocity_y += Gosu::offset_y(@angle, 2.5)

    end

    def update_position
        @x = rand * 640
        @y = rand * 480

        if Math.sqrt((@x - 300)*(@x - 300)) <= 100
            @x = rand * 640
        end

        if Math.sqrt((@y - 300)*(@y - 300)) <= 100
            @y = rand * 640
        end
    end
    def stay_on_screen
      @x %= 640
    end

    def move
        @x += @velocity_x
        @y += @velocity_y

        @x %= 640
        @y %= 480
    end
    def bill_fall
        @y += 3 
    end
    

    def draw
        @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle, 0.5, 0.5, 1, 1)
        bill_fall
    end

end

class Coin 
    attr_reader :x, :y
      def initialize
        @image = Gosu::Image.new("media2/coin.png")
        @x = @y = @velocity_x = @velocity_y = @angle = 0.0
        @x = rand * 640
        @y = 0
      end
      

    def update_velocity
        @angle = rand * 360
        @velocity_x += Gosu::offset_x(@angle, 2.5)
        @velocity_y += Gosu::offset_y(@angle, 2.5)

    end

    def update_position
        @x = rand * 640
        @y = rand * 480

        if Math.sqrt((@x - 300)*(@x - 300)) <= 100
            @x = rand * 640
        end

        if Math.sqrt((@y - 300)*(@y - 300)) <= 100
            @y = rand * 640
        end
    end
    def coin_fall
      @y += 5

    end 

    def move
        @x += @velocity_x
        @y += @velocity_y

        @x %= 640
        @y %= 480
    end

    def draw
        @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle, 0.5, 0.5, 1.5, 1.5)
        coin_fall
    end

end

class Bomb
  attr_reader :x, :y
      def initialize
        @image = Gosu::Image.new("media2/bomb.png")
        @x = @y = @velocity_x = @velocity_y = @angle = 0.0
        @x = rand * 640
        @y = 0
      end
      

    def update_velocity
        @angle = rand * 360
        @velocity_x += Gosu::offset_x(@angle, 2.5)
        @velocity_y += Gosu::offset_y(@angle, 2.5)

    end
    def bomb_fall
      @y+= 3
    end

    def update_position
        @x = rand * 640
        @y = rand * 480

        if Math.sqrt((@x - 300)*(@x - 300)) <= 100
            @x = rand * 640
        end

        if Math.sqrt((@y - 300)*(@y - 300)) <= 100
            @y = rand * 640
        end
    end

    def move
        @x += @velocity_x
        @y += @velocity_y

        @x %= 640
        @y %= 480
    end

    def draw
        @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle, 0.5, 0.5, 1.5, 1.5)
        bomb_fall
    end

end

Tutorial.new.show
