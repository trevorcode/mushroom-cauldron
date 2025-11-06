(local util (require :util))
(local lg love.graphics)

(fn update [b dt]
  (set b.hover? (util.cursor-within? b))
  (set b.pressed? (and b.hover? (love.mouse.isDown 1))))

(fn draw [b]
  (lg.setColor 0 0 0)
  (local shadow-offset (if b.pressed? -1 -3))
  (lg.rectangle :fill b.x b.y b.width b.height)
  (if b.hover? 
      (lg.setColor 0.8 0.8 0.8)
      (lg.setColor 0.9 0.9 0.5))
  (lg.rectangle :fill (+ b.x shadow-offset) (+ b.y shadow-offset) b.width b.height)
  (lg.setColor 1 1 1)
  (lg.print b.text
            (+ b.x b.t-off-x shadow-offset)
            (+ b.y b.t-off-y shadow-offset)))

(fn mousepressed [b]
  (when (util.cursor-within? b)
    (b.onclick)))

(fn keypressed [b key]
  (when (= b.keybinding key)
    (b.onclick)))

(fn new [{: text : x : y : width : height
          : t-off-x : t-off-y : onclick : keybinding
          &as button}]
  (set button.keypressed (or keypressed (fn [])))
  button)

{: update : draw : mousepressed : new : keypressed}
