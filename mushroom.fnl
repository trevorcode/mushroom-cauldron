(local util (require :util))
(local anim8 (require :lib.anim8))
(local ebus (require :event-bus))
(local assets (require :assets))

(local lg love.graphics)

(var shader-code
     "extern vec4 outlineColor;
extern vec2 stepSize; 

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen_coords) {
    vec4 pixel = Texel(texture, uv);
    if (pixel.a > 0.0) return pixel * color;

    float dx = 1.0 / stepSize.x;
    float dy = 1.0 / stepSize.y;

    float alpha = 0.0;
    alpha += Texel(texture, uv + vec2(dx, 0.0f)).a;
    alpha += Texel(texture, uv + vec2(-dx, 0.0f)).a;
    alpha += Texel(texture, uv + vec2(0.0f, dy)).a;
    alpha += Texel(texture, uv + vec2(0.0f, -dy)).a;

    if (alpha > 0.0) return outlineColor;
    return vec4(0.0, 0.0, 0.0, 0.0);
}
"
     )
(local shader (love.graphics.newShader shader-code))

(fn update [mushroom dt]
  (mushroom.animation:update dt)
  (when mushroom.pressed? 
    (set mushroom.pressed? (- mushroom.pressed? 1))
    (when (<= mushroom.pressed? 0)
      (set mushroom.pressed? nil)
      (set mushroom.animation mushroom.animations.idle)))
  (set mushroom.hover? (util.cursor-within? mushroom))
  (set mushroom.clicked? (and mushroom.hover? (love.mouse.isDown 1))))

(fn draw [mushroom]
  ;; (if mushroom.hover? 
  ;;     ;;(lg.setColor 0.2 0.2 1)
  ;;     ;;(lg.setColor 0.8 0.8 1)
  ;;     ) 
  ;; (when mushroom.clicked?
  ;;   ;;(lg.setColor 0.1 0.8 1)
  ;;   )
  ;; (when mushroom.pressed?
  ;;   ;;(lg.setColor 0.8 0.2 1)
  ;;   )
  (lg.setColor 1 1 1)
  (when (or mushroom.hover?
            mushroom.pressed?) 
    (lg.setShader shader)
    (shader:send "outlineColor" [1 1 1 1])
    (local (w h) (assets.mushroom-sheet:getDimensions))
    (shader:send "stepSize" [w h]))
  (mushroom.animation:draw assets.mushroom-sheet mushroom.x mushroom.y 0 2 2)
  (lg.setShader)
  )

(fn activate [mushroom]
  (when mushroom.pitch 
    (set mushroom.pressed? 10)
    (let [s (mushroom.sound:clone)]
      (ebus.push :note-played {:note mushroom.tone})
      (set mushroom.animation mushroom.animations.active)
      (mushroom.animation:gotoFrame 1)
      (mushroom.animation:resume)
      (s:setPitch mushroom.pitch)
      (s:play))))

(fn on-click [mushroom event]
  (when (util.cursor-within? mushroom)

    (activate mushroom)))

(fn keypressed [mushroom {: key}]
  (when (= mushroom.key key)
    (activate mushroom)))

(fn tone->keybind [tone]
  (case tone
    :c :q
    :d :w
    :e :e
    :f :r
    :g :u
    :a :i
    :b :o
    :high-c :p
    _ nil))

(fn tone->pitch [tone]
  (case tone
    :c 1.0
    :d (^ 2 (/ 2 12))
    :e (^ 2 (/ 4 12))
    :f (^ 2 (/ 5 12))
    :g (^ 2 (/ 7 12))
    :a (^ 2 (/ 9 12))
    :b (^ 2 (/ 11 12))
    :high-c 2
    _ nil))

(fn tone->anim-column [tone]
  (case tone
    :c 1
    :d 4
    :e 6
    :f 2
    :g 7
    :a 3
    :b 5
    :high-c 8
    _ nil))

(fn new [{: x : y : width : height : img
          : tone : sound &as mushroom}]
  (set mushroom.pitch (tone->pitch tone))
  (set mushroom.key (tone->keybind tone))
  (set mushroom.animations
       {:idle (anim8.newAnimation (assets.mushroom-animation-grid 1 (tone->anim-column tone)) 1)
        :active (anim8.newAnimation (assets.mushroom-animation-grid "1-4" (tone->anim-column tone) 1 (tone->anim-column tone)) 0.05 :pauseAtEnd)})
  (set mushroom.animation mushroom.animations.idle)
  (let [m mushroom]
    (ebus.subscribe :mousepressed (partial on-click m))
    (ebus.subscribe :keypressed (partial keypressed m))
    m))

{: new : draw : update }
