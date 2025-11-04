(require :lib.repl)
(local tick (require :lib.tick))
(local scene-manager (require :scene_manager))
(local fennel (require :lib.fennel))
(local ebus (require :event-bus))

(local push (require :lib.push))
(local (window-width window-height) (love.window.getDesktopDimensions))
(set _G.game-width 384)
(set _G.game-height 256)
(local test-scene (require :test_scene))

(fn love.load []
  ;;(set tick.framerate 60)

  (love.graphics.setDefaultFilter "nearest" "nearest")
  (push:setupScreen _G.game-width
                    _G.game-height
                    (* 0.4 window-width)
                    (* 0.4 window-height)
                    {:vsync true :resizable true})
  (scene-manager.change-scene test-scene))

(fn love.draw []
  (push:start)
  (scene-manager.draw)
  (push:finish))

(fn love.update [dt]
  (ebus.dispatch)
  (scene-manager.update dt))

(fn love.resize [w h]
  (push:resize w h))

(fn love.keypressed [key]
  (ebus.push :keypressed {:key key}))

(fn love.mousepressed [x y button istouch presses]
  (ebus.push :mousepressed {:x x :y y :button button
                            :istouch istouch
                            :presses presses}))

(fn love.mousereleased [x y button istouch presses]
  (ebus.push :mousereleased {:x x :y y :button button
                            :istouch istouch
                            :presses presses}))
