(require :love.event)

(local fennel (require :lib.fennel))

(fn read [cont?]
  (io.write (if cont? ".." ">> "))
  (io.flush)
  (.. (tostring (io.read)) "\n"))

(case ...
  (event-type channel)
  (while true
    (match (channel:demand)
      :write (-> (channel:demand)
                 (table.concat "\t")
                 (io.stdout:write "\n"))
      :error (-> (channel:demand)
                 (io.stderr:write "\n"))
      :read (->> (channel:demand)
                 read
                 (love.event.push event-type)))))

(let [chan (love.thread.newChannel)
      repl (coroutine.wrap #(fennel.repl $...))]
  (repl
   {:readChunk (fn [{: stack-size}]
                 (chan:push :read)
                 (chan:push (< 0 stack-size))
                 (coroutine.yield))
    :onValues (fn [vals]
                (chan:push :write)
                (chan:push vals))
    :onError (fn [errtype err]
               (chan:push :error)
               (chan:push err))
    :moduleName "lib.fennel"})
  (-> (love.filesystem.read "lib/repl.fnl")
      (#(fennel.compile-string $))
      (love.filesystem.newFileData "repl")
      love.thread.newThread
      (: :start :eval chan))
  (set love.handlers.eval repl))
