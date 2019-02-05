# filename resolution.rb
=begin
================================================================================
XPA Tilemap                                                      Version 0.34
by KK20                                                          4 May 2017
________________________________________________________________________________

 [ Version History ]
 
 Ver.      Date            Notes
 -----     -----------     ----------------------------------------------------
 0.34  ... 04 May 2017 ... Bug fixes:
                            - CallBackController was not disposing its contents,
                              causing a memory leak whenever a new Tilemap was
                              created (and eventually crashing the game)
 0.33  ... 30 Apr 2017 ... Bug fixes:
                            - Maps with empty autotiles would crash the game
                            - Tilesets without a graphic would crash the game
                            - The creation of empty autotiles would continually
                              spawn disposed Bitmap objects (related to above)
                            - 32x32 autotiles that animated would crash the game
 0.32  ... 25 Feb 2017 ... Bug fixes:
                            - Child viewports were having display issues when
                              tone changes were involved
                            - Viewport#flash had missing parameters
                            - Added more compatibility for XP games (thanks
                              LiTTleDRAgo!)
 0.31  ... 08 Feb 2017 ... Bug fixes:
                            - Bad logic with border sprites for non-wrapping map
                            - Problem with Plane objects not initialized with a
                              viewport, causing children-creation to crash
                            - Disable Graphics.resize_screen in Hime's script
                              for XP games as this method does not exist nor is
                              the code necessary to "break" the resolution limit
                            - RGSS does not support Array#cover?
                           Changes:
                            - The Resolution module is disabled for XPA
                            - If WEATHER_ADJUSTMENT is false, it will disable
                              all of the RPG::Weather and Screen classes
                              from loading rather than only some methods
                            - Input module for supporting different game window
                              sizes is disabled for XP as this feature does not
                              work in RGSS
 0.3   ... 04 Feb 2017 ... Bug fixes:
                            - A graphical bug involving priority tiles if the
                              MAX_PRIORITY_LAYERS is set to less than 5
                            - Loading autotiles in RPG::Cache has been revised
                              for better compatibility
                            - CallBackController added to replace the method 
                              implemented in v0.2b which prevented saving games
                           Additions:
                            - Commented out a majority of the anonymous scripter
                              code that breaks the resolution limit for RGSS3;
                              its ramifications are unknown at this point
                            - A new Plane rewrite which is merely just creating
                              more Plane objects
                            - Maps that do not wrap have a high z-level black 
                              sprite positioned around the map's borders
                            - New fullscreen and other window size options for
                              XPA games (will not work for XP)
                            - Tilesets that are not divisible by 32 will raise
                              an error rather than crash
                            - Maps with invalid tile ID's (caused when a tile
                              was placed with a taller tileset graphic, but then
                              the map uses a shorter tileset) no longer crash
                              the game
 0.13b ... 23 Oct 2016 ... Bug fixes:
                            - Resolutions not divisible by 32 would not show the
                              last row/column of tiles entirely
                           ** Fix added on top of v0.12b, not v0.2b, but is
                           ** included in all versions above this one
 0.2b  ... 07 Jun 2016 ... Bug fixes:
                            - Shaking still had issues
                           Additions:
                            - Maps can now wrap by putting [WRAP] in the map
                              name, due to a new way of drawing the map
                            - ...which also fixed the shaking above
                            - ...and can also allow vertical shaking
                            - Added Unlimited Resolution, an RMVXA script with
                              some changes
                            - Changing tileset and autotile bitmaps in-game will
                              not crash (assuming you know how to do that)
                            - Overall cleaning of code
 0.12b ... 27 Feb 2016 ... Bug fixes:
                            - Tiles with some transparency and priority were
                              being redrawn continuously on each other
                            - Setting the Plane bitmap to nil would crash
 0.11b ... 03 Nov 2014 ... Bug fixes:
                            - Table did not take in parameters upon initialize
                            - Centering of maps now shrinks Viewport sizes
                            - Fixed Tilemap#oy= logic
 0.1b  ... 02 Nov 2014 ... Initial release
________________________________________________________________________________

 [ Introduction ]
 
 In light of recent discoveries regarding the usage of RGSS3 in RPG Maker XP
 games, many users were left with a dilemma in choosing which Tilemap rewrite to
 use due to the vast differences between RGSS1's and RGSS3's Tilemap classes
 that would cause complications in this transition. I aimed to find the best
 Tilemap rewrite and decided that I would have to make my own. Like every other
 Tilemap rewrite before it, this implementation is in no ways perfect, boasting
 PROs and CONs.
 
 This script is intended to be used for RPG Maker XP games using the RGSS3
 library (unofficially coined RPG Maker XP Ace); however, it is entirely
 compatible with RPG Maker XP games in the RGSS1 library.
________________________________________________________________________________

 [ License ]
 
 This work is protected by the following license: 
 http://creativecommons.org/licenses/by-nc-sa/3.0/
 
********************************************************************************

You are free:

to Share - to copy, distribute and transmit the work
to Remix - to adapt the work

Under the following conditions:

Attribution:
You must attribute the work in the manner specified by the author or licensor, 
but not in any way that suggests that they endorse you or your use of the work.

Noncommercial:
You may not use this work for commercial purposes.

Share alike:
If you alter, transform, or build upon this work, you may distribute the 
resulting work only under the same or similar license to this one.

- For any reuse or distribution, you must make clear to others the license terms 
  of this work. The best way to do this is with a link to this web page.

- Any of the above conditions can be waived if you get permission from the 
  copyright holder.

- Nothing in this license impairs or restricts the author's moral rights.

********************************************************************************

 [ Instructions ]
 
 - Place this script below the default scripts but above Main.
 - Move 'XPATilemap.dll' into your project folder (same directory as 'Game.exe')
 - Configure values at the start of the script
________________________________________________________________________________

 [ Features ]
 
 About the script:
 - XP and XPA (RGSS1 and RGSS3) compatible, though designed for XPA
 - Define your own custom resolution
 - Adds new tilemap features
 - Maps that are smaller than the game resolution are automatically centered
 - Drawing methods written in C-language, which has faster pixel-by-pixel
   operations than Ruby
 
 Add-ons:
 - Customize frame rate animation and define unique patterns for your autotiles
 - Remove unnecessary priority layers to boost frames-per-second (FPS)
 - Extend the default RPG::Weather class to fit larger screens, or not
 - Change the way fullscreen works (or disable it), including a double and half-
   size window option (only for XPA)
 - more to add later...
________________________________________________________________________________

 [ Compatibility ]
 
 - There have been reports of Screen Flash not working for some users, though I
   have yet to receive any valid proof or ways to reproduce this issue
 - Your tileset must have dimensions divisible by 32. The game will raise an
   error otherwise.
________________________________________________________________________________

 [ Credits ]
 
 KK20 - Author of this script and DLL
 Blizzard - Tester and providing bug fixes
 LiTTleDRAgo - Reusing code from his edits to Custom Resolution and bug fixes
 Zexion - Tester and morale support
 ForeverZer0 - Reusing code from his Custom Resolution script, found here:
                http://forum.chaos-project.com/index.php/topic,7814.0.html
________________________________________________________________________________

 [ Contact ]
 
 To contact the author of this script, please visit 
                http://forum.chaos-project.com/index.php
                
 or send an email to
                        tscrane20@gmail.com
                        
================================================================================
=end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                       B E G I N   C O N F I G U R A T I O N
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#-------------------------------------------------------------------------------
# The game window's screen resolution. RPG Maker XP's default is [640, 480].
# Do note that a larger resolution is prone to sprite lag.
# Anything larger than the default resolution will enable the custom Plane class.
#-------------------------------------------------------------------------------
SCREEN_RESOLUTION = [Config::WINDOW_WIDTH, Config::WINDOW_HEIGHT]

#-------------------------------------------------------------------------------
# The largest level of priority your game uses. This value should be between
# 1 and 5. If using a large resolution, lowering the number of priority layers
# will help in reducing the lag.
#-------------------------------------------------------------------------------
MAX_PRIORITY_LAYERS = 5

#-------------------------------------------------------------------------------
# If using a larger resolution than 640x480, the default weather effects will
# not cover the entire map. It is recommended that you set this to true to
# compensate for that, unless you are using some custom weather script that can
# address this.
#-------------------------------------------------------------------------------
WEATHER_ADJUSTMENT = false

#-------------------------------------------------------------------------------
# When the map’s display_x/y variables extend beyond its borders, the map wraps 
# around to fill in the gaps. Setting this to true will prevent that, showing 
# black borders instead.
# If you want some maps to wrap around, putting [WRAP] in a map's name will
# allow this.
# Note that the custom Plane class will be enabled in order to create this
# effect regardless of your resolution size.
#-------------------------------------------------------------------------------
DISABLE_WRAP = false

#-------------------------------------------------------------------------------
# Set the animation frame rate for autotiles. By default, all autotiles will
# update on the 16th frame. You can change that by providing an array of numbers
# that represent how many frames that particular frame of animation will be
# visible for.
# Format:
#   when AUTOTILE_FILENAME then FRAME_DATA
# where FRAME_DATA is an array containing the number of frames that particular
# animation will play for before moving onto the next frame. Be sure to match
# the number of autotile animation frames with the number of elements you put
# into the array.
# Check the examples below.
#-------------------------------------------------------------------------------
def autotile_framerate(filename)
  case filename
  #------------------------------------------------------ START ------
  when '001-G_Water01' then [8, 8, 8, 8]      # Animates twice as fast
  when '009-G2_Water01' then [20, 20, 20, 20] # Animates a bit slower
  when '024-Ocean01' then [32, 16, 32, 16]    # Sine wave effect
  #------------------------------------------------------- END -------
  # Don't touch any of this below
  else
    return nil if filename == ''
    # Generates array of [16, 16, ...] based on autotile width 
    # (or nil if not animating autotile)
    w = RPG::Cache.autotile(filename).width
    h = RPG::Cache.autotile(filename).height
    if (h == 32 && w / 32 == 1) || (h == 192 && w / 256 == 1)
      return nil
    else
      return h == 32 ? Array.new(w/32){|i| 16} : Array.new(w/256){|i| 16}
    end
  end
end

XPACE = RUBY_VERSION == "1.9.2"

MAX_PRIORITY_LAYERS = 5 unless (1..5).include?(MAX_PRIORITY_LAYERS)

#===============================================================================
# ** NilClass
#===============================================================================
class NilClass
  unless method_defined?(:dispose)
    def dispose; end
    def disposed?; end
  end
end
#===============================================================================
# ** Bitmap
#===============================================================================
class Bitmap
  attr_accessor :filename
  alias set_filename_of_bitmap initialize
  def initialize(*args)
    # Associate the bitmap with the filename of the graphic; empty string otherwise
    @filename = args.size == 1 ? File.basename(args[0], '.*') : ''
    set_filename_of_bitmap(*args)
  end
end
#===============================================================================
# ** RPG::Cache
#===============================================================================
module RPG::Cache
  
  AUTO_INDEX = [
  
  [27,28,33,34],  [5,28,33,34],  [27,6,33,34],  [5,6,33,34],
  [27,28,33,12],  [5,28,33,12],  [27,6,33,12],  [5,6,33,12],
  [27,28,11,34],  [5,28,11,34],  [27,6,11,34],  [5,6,11,34],
  [27,28,11,12],  [5,28,11,12],  [27,6,11,12],  [5,6,11,12],
  [25,26,31,32],  [25,6,31,32],  [25,26,31,12], [25,6,31,12],
  [15,16,21,22],  [15,16,21,12], [15,16,11,22], [15,16,11,12],
  [29,30,35,36],  [29,30,11,36], [5,30,35,36],  [5,30,11,36],
  [39,40,45,46],  [5,40,45,46],  [39,6,45,46],  [5,6,45,46],
  [25,30,31,36],  [15,16,45,46], [13,14,19,20], [13,14,19,12],
  [17,18,23,24],  [17,18,11,24], [41,42,47,48], [5,42,47,48],
  [37,38,43,44],  [37,6,43,44],  [13,18,19,24], [13,14,43,44],
  [37,42,43,48],  [17,18,47,48], [13,18,43,48], [13,18,43,48]
    
  ]
  
  def self.autotile(filename)
    key = "Graphics/Autotiles/#{filename}"
    if !@cache.include?(key) || @cache[key].disposed? 
      # Load the autotile graphic.
      orig_bm = self.load_bitmap('Graphics/Autotiles/', filename)
      # Cache each configuration of this autotile.
      new_bm = self.format_autotiles(orig_bm, filename)
      if new_bm != orig_bm
        @cache[key].dispose
        @cache[key] = new_bm
      end
    end
    @cache[key]
  end

  def self.format_autotiles(bitmap, filename)
    if bitmap.height > 32 && bitmap.height < 256
      frames = bitmap.width / 96
      template = Bitmap.new(256*frames,192)
      template.filename = filename
      # Create a bitmap to use as a template for creation.
      (0..frames-1).each{|frame|
      (0...6).each {|i| (0...8).each {|j| AUTO_INDEX[8*i+j].each {|number|
        number -= 1
        x, y = 16 * (number % 6), 16 * (number / 6)
        rect = Rect.new(x + (frame * 96), y, 16, 16)
        template.blt((32 * j + x % 32) + (frame * 256), 32 * i + y % 32, bitmap, rect)
      }}}}
      return template
    else
      return bitmap
    end
  end
  
end
#===============================================================================
# ** CallBackController
#===============================================================================
module CallBackController
  @@callback = {}
  
  def self.clear
    @@callback.clear
  end
  
  def self.setup_callback(obj, proc)
    @@callback[obj.object_id] = proc
  end
  
  def self.call(obj, *args)
    @@callback[obj.object_id].call(*args) if @@callback[obj.object_id]
    true
  end
  
  def self.delete(obj)
    @@callback.delete(obj.object_id)
  end
  
end

#===============================================================================
# ** Viewport
#===============================================================================
class Viewport
  attr_accessor :offset_x, :offset_y
  
  alias zer0_viewport_resize_init initialize
  def initialize(x=0, y=0, width=SCREEN_RESOLUTION[0], height=SCREEN_RESOLUTION[1], override=false)
    # Variables needed for Viewport children (for the Plane rewrite); ignore if
    # your game resolution is not larger than 640x480
    @offset_x = @offset_y = 0
    if x.is_a?(Rect)
      # If first argument is a Rectangle, just use it as the argument.
      zer0_viewport_resize_init(x)
    elsif [x, y, width, height] == [0, 0, 640, 480] && !override 
      # Resize fullscreen viewport, unless explicitly overridden.
      zer0_viewport_resize_init(Rect.new(0, 0, SCREEN_RESOLUTION[0], SCREEN_RESOLUTION[1]))
    else
      # Call method normally.
      zer0_viewport_resize_init(Rect.new(x, y, width, height))
    end
  end
  
  def resize(*args)
    # Resize the viewport. Can call with (X, Y, WIDTH, HEIGHT) or (RECT).
    if args[0].is_a?(Rect)
      args[0].x += @offset_x
      args[0].y += @offset_y
      self.rect = args[0]
    else
      args[0] += @offset_x
      args[1] += @offset_y
      self.rect = Rect.new(*args)
    end
  end
end

#===============================================================================
# ** Tilemap
#===============================================================================
class Tilemap
  
  attr_accessor :tileset, :autotiles, :map_data, :priorities, :ground_sprite
  attr_reader :wrapping
  #---------------------------------------------------------------------------
  # Initialize
  #---------------------------------------------------------------------------
  def initialize(viewport = nil)
    # Ensure that all callbacks are removed to prevent memory leaks
    CallBackController.clear
    
    @viewport = viewport
    @layer_sprites = []
    @autotile_frame = []      #[[ANIMATION_DRAW_INDEX, CURRENT_LOGICAL_FRAME], ... ]
    @autotile_framedata = []  #[[DATA_FROM_CONFIGURATION_ABOVE], ... ]
    
    # Ensures that the bitmap width accounts for an extra tile
    # and is divisible by 32
    bitmap_width = ((SCREEN_RESOLUTION[0] / 32.0).ceil + 1) * 32
    # Create the priority layers
    ((SCREEN_RESOLUTION[1]/32.0).ceil + MAX_PRIORITY_LAYERS).times{ |i|
      s = Sprite.new(@viewport)
      s.bitmap = Bitmap.new(bitmap_width, MAX_PRIORITY_LAYERS * 32)
      @layer_sprites.push(s)
    }
    
    # Same reasons as bitmap_width, but for height
    bitmap_height = ((SCREEN_RESOLUTION[1] / 32.0).ceil + 1) * 32
    # Create the ground layer (priority 0)
    s = Sprite.new(@viewport)
    s.bitmap = Bitmap.new(bitmap_width, bitmap_height)
    @ground_sprite = s
    @ground_sprite.z = 0

    # Initialize remaining variables
    @redraw_tilemap = true
    @tileset = nil
    @autotiles = []
    proc = Proc.new { |x,y| @redraw_tilemap = true; setup_autotile(x) }
    CallBackController.setup_callback(@autotiles, proc)
    
    @map_data = nil
    
    @priorities = nil
    @old_ox = 0
    @old_oy = 0
    @ox = 0
    @oy = 0
    @ox_float = 0.0
    @oy_float = 0.0
    @shift = 0
    @wrapping = (!DISABLE_WRAP || (XPAT_MAP_INFOS[Game.map.map_id].name =~ /.*\[[Ww][Rr][Aa][Pp]\].*/) == 0) ? 1 : 0
    create_border_sprites
    
    # Set up the DLL calls
    @@update = Win32API::DrawMapsBitmap2
    @@autotile_update = Win32API::UpdateAutotiles
    @@initial_draw = Win32API::DrawMapsBitmap
    @empty_tile = Bitmap.new(32,32)
    Win32API::InitEmptyTile.call(@empty_tile.object_id)
    @black_tile = Bitmap.new(32,32)
    @black_tile.fill_rect(0,0,32,32,Color.new(0,0,0))
    Win32API::InitBlackTile.call(@black_tile.object_id)
    
  end
  #---------------------------------------------------------------------------
  # Setup autotile animation data
  #---------------------------------------------------------------------------
  def setup_autotile(i)
    # Get animation frame rate of the autotile
    bitmap = @autotiles[i]
    frames = bitmap.nil? ? nil : autotile_framerate(bitmap.filename)
    # If autotile doesn't animate
    if frames.nil?
      @autotile_frame[i] = [0,0]
      @autotile_framedata[i] = nil
    else
      # Save the frame rate data
      @autotile_framedata[i] = frames
      # Determine how long one animation cycle takes and indicate at what time
      # the next frame of animation occurs
      total = 0
      frame_checkpoints = []
      
      frames.each_index{|j| f = frames[j]
        total += f
        frame_checkpoints[j] = total
      }
      # Get animation frame for this autotile based on game time passed
      current_frame = Graphics.frame_count % total
      frame_checkpoints.each_index{|j| c = frame_checkpoints[j]
        next if c.nil?
        if c > current_frame
          @autotile_frame[i] = [j, c - current_frame]
          break
        end
      }
    end
  end
  #---------------------------------------------------------------------------
  # Creates four 32-pixel thick black sprites to surround the map. This is
  # only applied to maps that do not have wrapping enabled. This helps those
  # who have screen shaking in their maps.
  #---------------------------------------------------------------------------
  def create_border_sprites
    @border_sprites = []
    return if @wrapping == 1
    for i in 0..3
      s = Sprite.new(@viewport)
      s.z = 99999
      if i % 2 == 0
        b = Bitmap.new(SCREEN_RESOLUTION[0] + 64,32)
        s.x = -32
        s.y = i == 0 ? -32 : Game.map.height * 32
      else
        b = Bitmap.new(32,SCREEN_RESOLUTION[1] + 64)
        s.x = i == 1 ? -32 : Game.map.width * 32
        s.y = -32
      end
      b.fill_rect(0, 0, b.width, b.height, Color.new(0,0,0))
      s.bitmap = b
      @border_sprites.push(s)
    end
  end
  #---------------------------------------------------------------------------
  # Dispose tilemap
  #---------------------------------------------------------------------------
  def dispose
    @layer_sprites.each{|sprite| sprite.dispose}
    @ground_sprite.dispose
    @border_sprites.each{|sprite| sprite.dispose}
    CallBackController.clear
  end
  #---------------------------------------------------------------------------
  # Check if disposed tilemap
  #---------------------------------------------------------------------------
  def disposed?
    @layer_sprites[0].disposed?
  end
  #---------------------------------------------------------------------------
  # Get viewport
  #---------------------------------------------------------------------------
  def viewport
    @viewport
  end
  #---------------------------------------------------------------------------
  # Return if tilemap is visible
  #---------------------------------------------------------------------------
  def visible
    layer_sprites[0].visible
  end
  #---------------------------------------------------------------------------
  # Show or hide tilemap
  #---------------------------------------------------------------------------
  def visible=(bool)
    @layer_sprites.each{|sprite| sprite.visible = bool}
    @ground_sprite.visible = bool
  end
  #---------------------------------------------------------------------------
  # Set tileset
  #---------------------------------------------------------------------------
  def tileset=(bitmap)
    @tileset = bitmap
    if @tileset.width % 32 != 0 || @tileset.height % 32 != 0
      file = bitmap.filename
      raise "Your tileset graphic #{file} needs to be divisible by 32!"
    end
    @redraw_tilemap = true
  end
  #---------------------------------------------------------------------------
  # Set autotiles
  #---------------------------------------------------------------------------
  def autotiles=(array)
    CallBackController.delete(@autotiles)
    @autotiles = array
    proc = Proc.new { |i| @redraw_tilemap = true; setup_autotile(i) }
    CallBackController.setup_callback(@autotiles, proc)
    @redraw_tilemap = true
  end
  #---------------------------------------------------------------------------
  # Set map data
  #---------------------------------------------------------------------------
  def map_data=(table)
    CallBackController.delete(@map_data)
    @map_data = table
    proc = Proc.new { @redraw_tilemap = true }
    CallBackController.setup_callback(@map_data, proc)
    @redraw_tilemap = true
  end
  #---------------------------------------------------------------------------
  # Set map priorities
  #---------------------------------------------------------------------------
  def priorities=(table)
    CallBackController.delete(@priorities)
    @priorities = table
    proc = Proc.new { @redraw_tilemap = true }
    CallBackController.setup_callback(@priorities, proc)
    @redraw_tilemap = true
  end
  #---------------------------------------------------------------------------
  # Get horizontal shift
  #---------------------------------------------------------------------------
  def ox
    @ox + @ox_float
  end
  #---------------------------------------------------------------------------
  # Get vertical shift
  #---------------------------------------------------------------------------
  def oy
    @oy + @oy_float
  end
  #---------------------------------------------------------------------------
  # Shift tilemap horizontally
  #---------------------------------------------------------------------------
  def ox=(ox)
    @ox_float = (ox - ox.to_i) % 1
    @ox = ox.floor
    @border_sprites.each{ |s| 
      next if s.bitmap.height == 32
      s.ox = @ox
    }
  end
  #---------------------------------------------------------------------------
  # Shift tilemap vertically
  #---------------------------------------------------------------------------
  def oy=(oy)
    @oy_float = (oy - oy.to_i) % 1
    @oy = oy.floor
    @border_sprites.each{ |s| 
      next if s.bitmap.width == 32
      s.oy = @oy
    }
  end
  #---------------------------------------------------------------------------
  # Update tilemap graphics
  #---------------------------------------------------------------------------
  def update; end;
  def draw
    # Figure out what the new X and Y coordinates for the ground layer would be
    x = @old_ox - @ox
    @old_ox = @ox
    x += @ground_sprite.x

    y = @old_oy - @oy
    @old_oy = @oy
    y += @ground_sprite.y

    # No reason to do sprite shifting if we're just redrawing everything
    if !@redraw_tilemap
      # If layers would be too far to the left
      if x < @viewport.ox - 31
        # If still too far, then force redraw
        if x + 32 < @viewport.ox - 31
          @redraw_tilemap = true
        else
          # Shift all layers right by 32 and clear out left-most column
          x += 32
          @ground_sprite.bitmap.fill_rect(0, 0, 32, @ground_sprite.bitmap.height, Color.new(0,0,0,0))
          @layer_sprites.each{|sprite| 
            sprite.bitmap.fill_rect(0, 0, 32, sprite.bitmap.height, Color.new(0,0,0,0))
          }
          @shift += 1 # Redraw right column bit-flag (0001)
        end
      # If layers would be too far to the right
      elsif x > @viewport.ox
        # If still too far, then force redraw
        if x - 32 > @viewport.ox
          @redraw_tilemap = true
        else
          # Shift all layers left by 32 and clear out right-most column
          x -= 32
          @ground_sprite.bitmap.fill_rect(@ground_sprite.bitmap.width - 32, 0, 32, @ground_sprite.bitmap.height, Color.new(0,0,0,0))
          @layer_sprites.each{|sprite| 
            sprite.bitmap.fill_rect(sprite.bitmap.width - 32, 0, 32, sprite.bitmap.height, Color.new(0,0,0,0))
          }
          @shift += 2 # Redraw left column bit-flag (0010)
        end
      end
      # Apply the change in X to the layers
      if !@redraw_tilemap
        @ground_sprite.x = x
        @layer_sprites.each{|sprite| sprite.x = x}

        # If layers would be too far up
        if y < @viewport.oy - 31
          # If still too far, then force redraw
          if y + 32 < @viewport.oy - 31
            @redraw_tilemap = true
          else 
            y += 32
            layer = @layer_sprites.shift
            layer.bitmap.clear
            @layer_sprites.push(layer)
            # Clear out the rows in the layers to prepare for drawing in #update
            width = @layer_sprites[0].bitmap.width
            num = @layer_sprites.size
            (1...MAX_PRIORITY_LAYERS).each{ |index|
              @layer_sprites[num-index].bitmap.fill_rect(0, (index - 1) * 32, width, 32, Color.new(0,0,0,0))
            }
            @shift += 4 # Redraw bottom row bit-flag (0100)
          end
        # If layers would be too far down
        elsif y > @viewport.oy
          # If still too far, then force redraw
          if y - 32 > @viewport.oy
            @redraw_tilemap = true
          else
            y -= 32
            layer = @layer_sprites.pop
            layer.bitmap.clear
            @layer_sprites.unshift(layer)
            # Clear out the rows in the layers to prepare for drawing in #update
            width = @layer_sprites[0].bitmap.width
            (1...MAX_PRIORITY_LAYERS).each{ |index|
              @layer_sprites[index].bitmap.fill_rect(0, (MAX_PRIORITY_LAYERS - 1 - index) * 32, width, 32, Color.new(0,0,0,0))
            }
            @shift += 8 # Redraw top row bit-flag (1000)
          end
        end
        # Apply the change to layers' Y and Z values
        if !@redraw_tilemap
          @ground_sprite.y = y
          @layer_sprites.each_index{ |i| sprite = @layer_sprites[i]
            sprite.y = y - 32 * (MAX_PRIORITY_LAYERS - 1 - i)
            sprite.z = sprite.y + (192 - (5 - MAX_PRIORITY_LAYERS) * 32)
          }
        end
      end
    end

    autotile_need_update = []
    # Update autotile animation frames
    for i in 0..6
      autotile_need_update[i] = false
      # If this autotile doesn't animate, skip
      next if @autotile_framedata[i].nil?
      # Reduce frame count
      @autotile_frame[i][1] -= 1
      # Autotile requires update
      if @autotile_frame[i][1] == 0
        @autotile_frame[i][0] = (@autotile_frame[i][0] + 1) % @autotile_framedata[i].size
        @autotile_frame[i][1] = @autotile_framedata[i][@autotile_frame[i][0]]
        autotile_need_update[i] = true
      end
    end
    
    
    # Stop the update unless redrawing, there is shifting, or an autotile needs to update
    return unless @redraw_tilemap || @shift != 0 || !autotile_need_update.index(true).nil?

    # Set up the array for the priority layers
    layers = [@layer_sprites.size + 1]
    # Insert higher priority layers into the array in order (least to most y-value sprite)
    @layer_sprites.each{|sprite| layers.push(sprite.bitmap.object_id) }
    # Insert ground layer last in the array
    layers.push(@ground_sprite.bitmap.object_id)
    # Load autotile bitmap graphics into array
    tile_bms = [self.tileset.object_id]
    self.autotiles.each{|autotile| tile_bms.push(autotile.object_id) }
    # Store autotile animation frame data
    autotiledata = []
    for i in 0..6
      autotiledata.push(@autotile_frame[i][0])
      autotiledata.push(autotile_need_update[i] ? 1 : 0)
    end
    # Fills in remaining information of other tilemaps
    misc_data = [@ox + @viewport.ox, @oy + @viewport.oy,
      self.map_data.object_id, self.priorities.object_id, @shift, 
      MAX_PRIORITY_LAYERS, @wrapping]
    
    # If forcing fresh redraw of the map (or drawing for first time)
    if @redraw_tilemap
      # Initialize layer sprite positions and clear them for drawing
      @ground_sprite.bitmap.clear
      @ground_sprite.x = (@viewport.ox - @viewport.ox % 32) - (@ox % 32)
      @ground_sprite.x += 32 if @ground_sprite.x < @viewport.ox - 31
      @ground_sprite.y = (@viewport.oy - @viewport.oy % 32) - (@oy % 32)
      @ground_sprite.y += 32 if @ground_sprite.y < @viewport.oy - 31

      y_buffer = 32 * (MAX_PRIORITY_LAYERS - 1)
      z_buffer = MAX_PRIORITY_LAYERS * 32 + 32
      @layer_sprites.each_index{|i| layer = @layer_sprites[i]
        layer.bitmap.clear
        layer.x = @ground_sprite.x
        layer.y = @ground_sprite.y - y_buffer + 32 * i
        layer.z = layer.y + z_buffer
      }
      # Make DLL call
      @@initial_draw.call(layers.pack("L*"), tile_bms.pack("L*"), autotiledata.pack("L*"), misc_data.pack("L*"))
    elsif @shift != 0
      # Update for shifting
      @@update.call(layers.pack("L*"), tile_bms.pack("L*"), autotiledata.pack("L*"), misc_data.pack("L*"))
    end
    # Check for autotile updates (at least one autotile needs an update)
    # No need if redrawn tilemap since it already handled the updated autotiles
    if !@redraw_tilemap && !autotile_need_update.index(true).nil?
      @@autotile_update.call(layers.pack("L*"), tile_bms.pack("L*"), autotiledata.pack("L*"), misc_data.pack("L*"))
    end
    # Turn off flag
    @redraw_tilemap = false
    # Reset shift flag
    @shift = 0
  end
  
end
#===============================================================================
# ** Player
#===============================================================================
class Player
  
  CENTER_X = ((SCREEN_RESOLUTION[0] / 2) - 16) * 4    # Center screen x-coordinate * 4
  CENTER_Y = ((SCREEN_RESOLUTION[1] / 2) - 16) * 4    # Center screen y-coordinate * 4
  
  def center(x, y)
    # Recalculate the screen center based on the new resolution.
    max_x = ((Game.map.width - (SCREEN_RESOLUTION[0]/32.0)) * 128).to_i
    max_y = ((Game.map.height - (SCREEN_RESOLUTION[1]/32.0)) * 128).to_i
    Game.map.display_x = [0, [x * 128 - CENTER_X, max_x].min].max
    Game.map.display_y = [0, [y * 128 - CENTER_Y, max_y].min].max
  end
end
#===============================================================================
# ** Map
#===============================================================================
class Map
  alias zer0_map_edge_setup setup
  def setup(map_id)
    zer0_map_edge_setup(map_id)
    # Find the displayed area of the map in tiles. No calcualting every step.
    @map_edge = [self.width - (SCREEN_RESOLUTION[0]/32.0), self.height - (SCREEN_RESOLUTION[1]/32.0)]
    @map_edge.collect! {|size| size * 128 }
    # Change the map center if map is smaller than the resolution
    if Game.map.width < SCREEN_RESOLUTION[0] / 32
      puts 1
      Player.const_set(:CENTER_X, Game.map.width * 128)
    else
      puts 2
      Player.const_set(:CENTER_X, ((SCREEN_RESOLUTION[0] / 2) - 16) * 4)
    end
    if Game.map.height < SCREEN_RESOLUTION[1] / 32
      Player.const_set(:CENTER_Y, Game.map.height * 128)
    else
      Player.const_set(:CENTER_Y, ((SCREEN_RESOLUTION[1] / 2) - 16) * 4)
    end
  end

  def scroll_down(distance)
    # Find point that the map edge meets the screen edge, using custom size.
    @display_y = [@display_y + distance, @map_edge[1]].min
  end

  def scroll_right(distance)
    # Find point that the map edge meets the screen edge, using custom size.
    @display_x = [@display_x + distance, @map_edge[0]].min
  end
end

# Override set-methods to allow callbacks (necessary for Tilemap)
#===============================================================================
# ** Array
#===============================================================================
class Array
  alias flag_changes_to_set []=
  def []=(x, y)
    flag_changes_to_set(x, y)
    CallBackController.call(self, x, y)
  end
end
#===============================================================================
# ** Table
#===============================================================================
class Table
  alias flag_changes_to_set []=
  def []=(*args)
    flag_changes_to_set(*args)
    CallBackController.call(self, *args)
  end
end

if WEATHER_ADJUSTMENT
#===============================================================================
# ** RPG::Weather
#===============================================================================
class RPG::Weather
  
  alias add_more_weather_sprites initialize
  def initialize(vp = nil)
    add_more_weather_sprites(vp)
    total_sprites = SCREEN_RESOLUTION[0] * SCREEN_RESOLUTION[1] / 7680
    if total_sprites > 40
      for i in 1..(total_sprites - 40)
        sprite = Sprite.new(vp)
        sprite.z = 1000
        sprite.visible = false
        sprite.opacity = 0
        @sprites.push(sprite)
      end
    end
  end
  
  def type=(type)
    return if @type == type
    @type = type
    case @type
    when 1
      bitmap = @rain_bitmap
    when 2
      bitmap = @storm_bitmap
    when 3
      bitmap = @snow_bitmap
    else
      bitmap = nil
    end
    for i in 1..@sprites.size
      sprite = @sprites[i]
      if sprite != nil
        sprite.visible = (i <= @max)
        sprite.bitmap = bitmap
      end
    end
  end
  
  def max=(max)
    return if @max == max;
    @max = [[max, 0].max, @sprites.size].min
    for i in 1..@sprites.size
      sprite = @sprites[i]
      if sprite != nil
        sprite.visible = (i <= @max)
      end
    end
  end
  
  def update
    return if @type == 0
    for i in 1..@max
      sprite = @sprites[i]
      if sprite == nil
        break
      end
      if @type == 1
        sprite.x -= 2
        sprite.y += 16
        sprite.opacity -= 8
      end
      if @type == 2
        sprite.x -= 8
        sprite.y += 16
        sprite.opacity -= 12
      end
      if @type == 3
        sprite.x -= 2
        sprite.y += 8
        sprite.opacity -= 8
      end
      x = sprite.x - @ox
      y = sprite.y - @oy
      if sprite.opacity < 64
        sprite.x = rand(SCREEN_RESOLUTION[0] + 100) - 100 + @ox
        sprite.y = rand(SCREEN_RESOLUTION[0] + 200) - 200 + @oy
        sprite.opacity = 160 + rand(96)
      end
    end
  end
  
end
#===============================================================================
# ** Screen
#===============================================================================
class Screen
  #--------------------------------------------------------------------------
  # * Set Weather
  #     type : type
  #     power : strength
  #     duration : time
  #--------------------------------------------------------------------------
  def weather(type, power, duration)
    @weather_type_target = type
    if @weather_type_target != 0
      @weather_type = @weather_type_target
    end
    if @weather_type_target == 0
      @weather_max_target = 0.0
    else
      num = SCREEN_RESOLUTION[0] * SCREEN_RESOLUTION[1] / 76800.0
      @weather_max_target = (power + 1) * num
    end
    @weather_duration = duration
    if @weather_duration == 0
      @weather_type = @weather_type_target
      @weather_max = @weather_max_target
    end
  end
  
end

end # if WEATHER_ADJUSTMENT
#===============================================================================
# ** MapSprite
#===============================================================================
class MapSprite

  alias init_for_centered_small_maps initialize
  #---------------------------------------------------------------------------
  # Resize and reposition viewport so that it fits smaller maps
  #---------------------------------------------------------------------------
  def initialize
    @center_offsets = [0,0]
    if Game.map.width < SCREEN_RESOLUTION[0] / 32
      x = 0#(SCREEN_RESOLUTION[0] - Game.map.width * 32) / 2
    else
      x = 0
    end
    if Game.map.height < SCREEN_RESOLUTION[1] / 32
      y = 0#(SCREEN_RESOLUTION[1] - Game.map.height * 32) / 2
    else
      y = 0
    end
    init_for_centered_small_maps
    w = [Game.map.width  * 32 , SCREEN_RESOLUTION[0]].min
    h = [Game.map.height * 32 , SCREEN_RESOLUTION[1]].min
    @viewport1.resize(x,y,w,h)
  end
  #---------------------------------------------------------------------------
  # Puts the tilemap update method at the end, ensuring that both
  # @tilemap.ox/oy and @viewport1.ox/oy are set.
  #---------------------------------------------------------------------------
  alias update_tilemap_for_real update
  def update
    update_tilemap_for_real
    @tilemap.draw
  end
end

# The following script will only be enabled if the resolution is bigger than the
# default OR if the game does not want certain maps to wrap around.
if DISABLE_WRAP || SCREEN_RESOLUTION[0] > 640 || SCREEN_RESOLUTION[1] > 480
#--------------------------------------------[Unlimited Resolution by Hime]-----
=begin
#===============================================================================
 Title: Unlimited Resolution 
 Date: Oct 24, 2013
 Author: Hime ( ** Modified by KK20 ** )
--------------------------------------------------------------------------------   
 Terms of Use
 Free
--------------------------------------------------------------------------------
 Description
 
 This script modifies Graphics.resize_screen to overcome the 640x480 limitation.
 It also includes some modifications to module Graphics such as allowing the
 default fade transition to cover the entire screen.
 
 Now you can have arbitrarily large game resolutions.
--------------------------------------------------------------------------------
 Credits
 
 Unknown author for overcoming the 640x480 limitation
 Lantier, from RMW forums for posting the snippet above
 Esrever for handling the viewport
 Jet, for the custom Graphics code
 FenixFyre, for the Plane class fix
 Kaelan, for several bug fixes
--------------------------------------------------------------------------------
 KK20 Notes:
 - Plane class was rewritten from the original script. Certain lines in the
   unknown scripter's code can be omitted entirely to allow this implementation.
 - Likewise, the Viewport class needed new methods to handle this Plane rewrite.
 - This entire script only applies to games that go beyond the default 640x480
   resolution.
 
#===============================================================================
=end
unless XPACE
class Bitmap
  #----------------------------------------------------------------------------
  # ● New method: address
  #----------------------------------------------------------------------------
  def address
    @rtlmemory_pi ||= Win32API.new('kernel32','RtlMoveMemory','pii','i')
    @address ||= (  @rtlmemory_pi.call(a="\0"*4, __id__*2+16, 4)
                      @rtlmemory_pi.call(a, a.unpack('L')[0]+8, 4)
                      @rtlmemory_pi.call(a, a.unpack('L')[0]+16, 4)
                      a.unpack('L')[0]    )
  end
end
end
#===============================================================================
# ** Viewport
#===============================================================================
class Viewport
  attr_accessor :parent, :children
  
  alias init_children_vps initialize
  def initialize(*args)
    @children = []
    @parent = false
    init_children_vps(*args)
  end
  
  alias dispose_parent dispose
  def dispose
    @children.each{|child| child.dispose} if @parent
    dispose_parent
  end
  
  alias flash_parent flash
  def flash(color, duration)
    if @parent
      @children.each{|child| child.flash_parent(color, duration)}
    else
      flash_parent(color, duration)
    end
  end
  
  alias update_parent update
  def update
    @children.each{|child| child.update} if @parent
    update_parent
  end
  
  alias resize_trigger resize
  def resize(*args)
    @children.each{ |child| 
      if args[0].is_a?(Rect)
        rect = args[0]
        new_args = Rect.new(rect.x,rect.y,child.rect.width,child.rect.height)
      else
        new_args = [args[0],args[1]]
        new_args[2] = child.rect.width
        new_args[3] = child.rect.height
      end
      child.resize_trigger(*new_args)
    } if @parent
    resize_trigger(*args)
  end
  
  alias set_trigger_vp_ox ox=
  def ox=(nx)
    return if self.ox == nx
    set_trigger_vp_ox(nx)
    @children.each{|child| child.ox = nx}
  end
  
  alias set_trigger_vp_oy oy=
  def oy=(ny)
    return if self.oy == ny
    set_trigger_vp_oy(ny)
    @children.each{|child| child.oy = ny}
  end
  
  alias tone_parent tone=
  def tone=(t)
    if @parent
      @children.each{|child| child.tone_parent(t)}
    else
      tone_parent(t)
    end
  end

end
#===============================================================================
# ** Plane
#===============================================================================
class Plane
  attr_accessor :offset_x, :offset_y
  
  alias parent_initialize initialize
  def initialize(viewport=nil,parent=true)
    @parent = parent
    @children = []
    parent_initialize(viewport)
    @offset_x = 0
    @offset_y = 0
    # If the parent Plane object; but don't make more children if already have
    # some. This occurs in MapSprite when initializing the Panorama and Fog
    if @parent && viewport
      viewport.parent = true
      create_children
    end
  end
  
  def create_children
    gw = [SCREEN_RESOLUTION[0], Game.map.width * 32].min
    gh = [SCREEN_RESOLUTION[1], Game.map.height * 32].min
    w = (gw - 1) / 640
    h = (gh - 1) / 480
    for y in 0..h
      for x in 0..w
        # This is the top-left default/parent Plane, so skip it
        #next if x == 0 && y == 0
        # Create viewport unless it already exists
        width = w > 0 && x == w ? gw - 640 : 640
        height = h > 0 && y == h ? gh - 480 : 480
        vp = Viewport.new(x * 640, y * 480, width, height, true)
        vp.offset_x = x * 640
        vp.offset_y = y * 480
        # Have to do this in order to prevent overlapping with the parent
        # (for MapSprite viewport1 mainly)
        vp.z = self.viewport.z - 1
        self.viewport.children.push(vp)
        # Create the child Plane
        plane = Plane.new(vp,false)
        plane.offset_x = x * 640
        plane.ox = 0
        plane.offset_y = y * 480
        plane.oy = 0
        # Push to array
        @children.push(plane)
      end
    end
  end
  
  # For the remaining Plane properties, if the parent changes, so do its children
  
  alias dispose_parent dispose
  def dispose
    @children.each{|child| child.dispose} if @parent
    dispose_parent
  end
  
  alias zoom_x_parent zoom_x=
  def zoom_x=(new_val)
    new_val = 0 if new_val < 0
    @children.each{|child| child.zoom_x_parent(new_val)} if @parent
    zoom_x_parent(new_val)
  end
  
  alias zoom_y_parent zoom_y=
  def zoom_y=(new_val)
    new_val = 0 if new_val < 0
    @children.each{|child| child.zoom_y_parent(new_val)} if @parent
    zoom_y_parent(new_val)
  end
  
  alias ox_parent ox=
  def ox=(new_val)
    @children.each{|child| child.ox = new_val} if @parent
    ox_parent(new_val + @offset_x)
  end
  
  alias oy_parent oy=
  def oy=(new_val)
    @children.each{|child| child.oy = new_val} if @parent
    oy_parent(new_val + @offset_y)
  end
  
  alias bitmap_parent bitmap=
  def bitmap=(new_val)
    @children.each{|child| child.bitmap_parent(new_val)} if @parent
    #bitmap_parent(new_val)
  end
  
  alias visible_parent visible=
  def visible=(new_val)
    @children.each{|child| child.visible_parent(new_val)} if @parent
    visible_parent(new_val)
  end
  
  alias z_parent z=
  def z=(new_val)
    # Because the children spawn new Viewports, they have to be lower than the
    # parent's viewport to prevent drawing OVER the parent...unless the Plane's
    # z-value is more than zero, in which case the children viewports NEED to be
    # higher than the parent's. By doing this, we can have panoramas be below
    # the tilemap and fogs be over the tilemap.
    if @parent && @children[0]
      child = @children[0]
      if new_val > 0 && child.viewport.z < self.viewport.z
        @children.each{|child| child.viewport.z += 1}
      elsif new_val <= 0 && child.viewport.z >= self.viewport.z
        @children.each{|child| child.viewport.z -= 1}
      end
    end
    
    @children.each{|child| child.z_parent(new_val)} if @parent
    z_parent(new_val)
  end
  
  alias opacity_parent opacity=
  def opacity=(new_val)
    @children.each{|child| child.opacity_parent(new_val)} if @parent
    opacity_parent(new_val)
  end
  
  alias color_parent color=
  def color=(new_val)
    if @parent
      @children.each{|child| child.color_parent(new_val)}
    else
      color_parent(new_val)
    end
  end
  
  alias blend_type_parent blend_type=
  def blend_type=(new_val)
    @children.each{|child| child.blend_type_parent(new_val)} if @parent
    blend_type_parent(new_val)
  end 
  
  alias tone_parent tone=
  def tone=(new_val)
    if @parent
      @children.each{|child| child.tone_parent(new_val)}
    else
      tone_parent(new_val)
    end
  end
  
end
#------------------------------------------[End of Unlimited Resolution]--------
end

XPAT_MAP_INFOS = load_data("Data/MapInfos.rxdata")