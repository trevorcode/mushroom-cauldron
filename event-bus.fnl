(local subscribers {}) 
(local events [])

(fn subscribe [eventType callback]
  (case (?. subscribers eventType)
    e (table.insert e callback)
    nil (set (. subscribers eventType) [callback])))

(fn push [eventType event]
  (tset event :type eventType)
  (table.insert events event))

(fn dispatch-recur [events event-count]
  (when (and (< 0 (length events))
             (< event-count 100))
    (let [event (table.remove events 1)
          callbacks (?. subscribers event.type)]
      (when callbacks 
        (each [_ c (ipairs callbacks)]
          (c event)))
      (tail! (dispatch-recur events (+ 1 event-count))))))

(fn dispatch []
  (dispatch-recur events 0))

(comment 
 (subscribe :on-click (fn [] (print "yo")))  
 (push :on-click {:yo "dawg"})
 (dispatch))

{: push : dispatch : subscribe}
