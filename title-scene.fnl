(local scene {})
(local ebus (require :event-bus))
(local assets (require :assets))
(local flux (require :lib.flux))
(local button (require :button))

(local lg love.graphics)
(local start-button (button.new
                     {:x 50 :y 50 :text "Play"
                      :width 100 :height 80
                      :t-off-x 0 :t-off-y 0
                      :onclick (fn []
                                 (ebus.push :change-scene {:new-scene :game-scene}))}))

(fn scene.load [])
(fn scene.update [dt]
  (button.update start-button dt))

(fn scene.draw []
  (button.draw start-button))

(fn scene.keypressed [key]
  (button.keypressed start-button key))

(fn scene.mousepressed [x y mouse-button istouch presses]
  (button.mousepressed start-button))

(fn scene.mousereleased [x y button istouch presses])

scene
