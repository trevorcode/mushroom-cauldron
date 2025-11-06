(local subscribers {}) 
(local events [])

(fn subscribe [eventType callback ?category]
  (let [category (or ?category :scene)]
    (case (?. subscribers eventType)
      e (table.insert e {:callback callback
                         :category category})
      nil (set (. subscribers eventType) [{:callback callback
                                           :category category}]))))

(fn clear-subscriptions [category]
  (each [eventType callbacks (pairs subscribers)]
    (set (. subscribers eventType)
         (icollect [_ c (ipairs callbacks)]
                 (when (not= category c.category)
                     c)))))

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
          (c.callback event)))
      (tail! (dispatch-recur events (+ 1 event-count))))))

(fn dispatch []
  (dispatch-recur events 0))

(comment 
 (subscribe :on-click (fn [] (print "yo")))  
 (push :on-click {:yo "dawg"})
 (dispatch))

{: push : dispatch : subscribe : clear-subscriptions}
