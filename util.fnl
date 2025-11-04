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

{: point-within? : cursor-within? : cursor-position}
