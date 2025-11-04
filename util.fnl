(local push (require :lib.push))

(fn point-within? [point boundingBox]
  (if (and point boundingBox)
    (let [{:x x :y y} point
          {:x x2 :y y2
           :width width
           :height height} boundingBox]
      (and width height x2 y2 x y
           (<= x2 x (+ width x2))
           (<= y2 y (+ height y2))))
    false))

(fn cursor-position []
  (push:toGame (love.mouse.getPosition)))

(fn cursor-within? [boundingBox]
  (let [(x y) (cursor-position)
        point {:x x :y y}]
    (point-within? point boundingBox)))

(fn notes-equal? [t1 t2]
  (var equal? true)
  (if (= (length t1) (length t2))
      (for [i 1 (length t1) &until (not equal?)]
        (when (not= (. t1 i) (. t2 i))
          (set equal? false)))
      (set equal? false))
  equal?)

{: point-within? : cursor-within? : cursor-position : notes-equal?}
