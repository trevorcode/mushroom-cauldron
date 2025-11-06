(local bigbook {})
(local lg love.graphics)
(local assets (require :assets))
(local ebus (require :event-bus))
(local util (require :util))
(local song-module (require :songs))
(local songs (song-module.new))
(local button (require :button))
(var page 1)

(fn next-page []
  (when (< 1 page)
    (set page (- page 1))))

(fn prev-page []
  (when (< page (/ (length songs) 2))
    (set page (+ page 1))))

(fn close []
  (ebus.push :book-close {}))

(local buttons
       [(button.new {:text "Next" :x 270 :y 160 :width 50 :height 18
                     :t-off-x 5 :t-off-y 1 :keybinding :l
                     :onclick prev-page})
        (button.new {:text "Back" :x 70 :y 160 :width 50 :height 18
                     :t-off-x 5 :t-off-y 1 :keybinding :k
                     :onclick next-page})
        (button.new {:text "X" :x 310 :y 20 :width 15 :height 18
                     :t-off-x 3 :t-off-y 1 :keybinding :h
                     :onclick close})])

(fn draw-notes [notes x y]
  (each [i note (ipairs notes)]
    (let [color (case note
                  :c [0.6 0 0.6]
                  :d [0.3 0 0.6]
                  :e [0 0.4 0.8]
                  :f [0 0.4 0]
                  :g [0.9 0.9 0.4]
                  :a [0.9 0.6 0.2]
                  :b [0.7 0.1 0.1]
                  :high-c [0.3 0.2 0.1])
          row (math.floor (/ (- i 1) 10))
          new-x (+ x (* (% (- i 1) 10) 12))
          new-y (+ y (* 14 row))]
      (lg.setColor color)
      (lg.rectangle :fill new-x new-y 10 10)))
  (lg.setColor 1 1 1))

(fn bigbook.draw []
  (let [song1-index (+ 1 (* 2 (- page 1)))
        song2-index (* 2 page)
        song1 (. songs song1-index)
        song2 (?. songs song2-index)]
    (lg.draw assets.bigbook -100 -40 0 3 3)
    (lg.print song1-index 100 190)
    (lg.print song1.name 50 50)
    (draw-notes song1.notes 50 80)
    
    (when song2 
      (lg.print song2-index 260 190)
      (lg.print song2.name 205 50)
      (draw-notes song2.notes 205 80))

    (each [_ b (ipairs buttons)]
      (button.draw b))))

(fn bigbook.update [dt]
  (each [_ b (ipairs buttons)]
    (button.update b dt)))

(fn bigbook.mousepressed []
  (each [_ b (ipairs buttons)]
    (button.mousepressed b)))

(fn bigbook.keypressed [key]
  (each [_ b (ipairs buttons)]
    (button.keypressed b key)))

bigbook
