(local util (require :util))
(local lg love.graphics)

(fn update [b dt]
  (set b.hover? (util.cursor-within? b))
  (set b.pressed? (and b.hover? (love.mouse.isDown 1))))

(fn draw [b]
  (love.graphics.push)
  (love.graphics.translate (+ b.x (/ b.width 2)) (+ b.y (/ b.height 2)))
  (local origin-x (- 0 (/ b.width 2)))
  (local origin-y (- 0 (/ b.height 2)))
  (love.graphics.rotate b.rotation)
  (lg.setColor 0 0 0)
  (local shadow-offset (if b.pressed? -1 -3))
  ;; (lg.rectangle :fill b.x b.y b.width b.height)
  (lg.rectangle :fill origin-x origin-y b.width b.height)
  (if b.hover? 
      (lg.setColor 0.7 0.7 0.7)
      (lg.setColor (/ 241 255) (/ 140 255) (/ 72 255)))
  (lg.rectangle :fill (+ origin-x shadow-offset) (+ origin-y shadow-offset) b.width b.height)
  (lg.setColor 1 1 1)
  (lg.print b.text
            (+ origin-x b.t-off-x shadow-offset)
            (+ origin-y b.t-off-y shadow-offset)
            0 b.txt-size b.txt-size )
  (love.graphics.pop))

(fn mousepressed [b]
  (when (util.cursor-within? b)
    (b.onclick)))

(fn keypressed [b key]
  (when (= b.keybinding key)
    (b.onclick)))

(fn new [{: text : x : y : width : height
          : t-off-x : t-off-y : onclick : keybinding
          : txt-size
          &as button}]
  (set button.txt-size (or txt-size 1))
  (set button.rotation 0)
  (set button.keypressed (or keypressed (fn [])))
  button)

{: update : draw : mousepressed : new : keypressed}
