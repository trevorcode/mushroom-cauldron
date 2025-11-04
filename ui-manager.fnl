(var clickable-elements nil)
(var keypressable nil)

(fn register-clickable [ui-elements]
  (set elements ui-elements))


(fn mousepressed [x y button istouch presses]
  (scene.mousepressed x y button istouch presses))
(fn mousereleased [x y button istouch presses]
  (scene.mousereleased x y button istouch presses))

{: change-scene : update : draw : keypressed : mousepressed
 : mousereleased}
