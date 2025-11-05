(local test {})
(local ebus (require :event-bus))
(local state (require :test-scene-state))
(local fennel (require :lib.fennel))
(local util (require :util))
(local songs (require :songs))
(local assets (require :assets))
(local anim8 (require :lib.anim8))

(local mushroom (require :mushroom))
(local cauldron (require :cauldron))

(local lg love.graphics)

(var outline-shader-code
     "extern vec4 outlineColor;
extern vec2 stepSize; 

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screenCoords) {
    vec4 pixel = Texel(texture, uv);
    if (pixel.a > 0.0) {
      return pixel * color;
    }

    float alpha = 0.0;
    alpha += Texel(texture, uv + vec2(stepSize.x, 0.0f)).a;
    alpha += Texel(texture, uv + vec2(-stepSize.x, 0.0f)).a;
    alpha += Texel(texture, uv + vec2(0.0f, stepSize.y)).a;
    alpha += Texel(texture, uv + vec2(0.0f, -stepSize.y)).a;

    if (alpha > 0.0) {
      return outlineColor;
    }
    else {
      return vec4(0.0, 0.0, 0.0, 0.0);
    }
}
")

(set assets.outline-shader (love.graphics.newShader outline-shader-code))

(fn mushroom-played [{:note note}]
  (table.insert state.notes note)
  (each [_ song (ipairs songs)]
    (when (util.notes-equal? state.notes song.notes)
      (set state.notes [])
      (ebus.push :song-played song)
      (print song.name))))

(fn cauldron-clear []
  (set state.notes []))

(fn test.keypressed [{:key key}]
  (if (= key :a)
      (love.event.quit)))

(fn load-assets []
  (set assets.bell-sound (love.audio.newSource :assets/bell.wav :static))
  (set assets.water-sound (love.audio.newSource :assets/water.wav :static))
  (set assets.background (love.graphics.newImage :assets/mushroomcauldronbackground.png))
  (set assets.cauldron-sheet (love.graphics.newImage :assets/cauldron.png))
  (set assets.cauldron-animation-grid
       (anim8.newGrid 76 49
                      (assets.cauldron-sheet:getWidth)
                      (assets.cauldron-sheet:getHeight)))
  (set assets.mushroom-sheet (love.graphics.newImage :assets/mushrooms.png))
  (set assets.mushroom-animation-grid
       (anim8.newGrid 22 22
                      (assets.mushroom-sheet:getWidth)
                      (assets.mushroom-sheet:getHeight))))

(fn test.load []
  (ebus.clear-subscriptions)
  (ebus.subscribe :keypressed test.keypressed)
  (ebus.subscribe :note-played mushroom-played)
  (ebus.subscribe :cauldron-cleared cauldron-clear)
  (load-assets)
  (set state.cauldron (cauldron.new {:x 100 :y 100 :width (* 2 76) :height (* 2 49)}))
  (set state.mushrooms [(mushroom.new {:x 0 :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :c})
                        (mushroom.new {:x (* 46 1) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :d})
                        (mushroom.new {:x (* 46 2) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :e})
                        (mushroom.new {:x (* 46 3) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :f})
                        (mushroom.new {:x (* 46 4) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :g})
                        (mushroom.new {:x (* 46 5) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :a})
                        (mushroom.new {:x (* 46 6) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :b})
                        (mushroom.new {:x (* 46 7) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :high-c})]))

(fn test.update [dt]
  (cauldron.update state.cauldron state.notes dt)
  (each [_ m (pairs state.mushrooms)] 
    (mushroom.update m dt)))

(fn test.draw []
  (lg.draw assets.background 0 0 0 2 2)
  (lg.print (fennel.view state.notes) 0 50)
  (lg.print (love.timer.getFPS) (- _G.game-width 70) 0 0 1)
  (cauldron.draw state.cauldron)
  (each [_ m (pairs state.mushrooms)] 
    (mushroom.draw m))
  

  )

test
