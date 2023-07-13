#!/usr/bin/env clojure

(def people [
  { :name "Ingy" :favs ["coffee" "yellow"] }
  { :name "Gugod" :favs ["tea" "blue"] }])

(defn about [{:keys [name] [color drink] :favs}]
  (println (str name " wears " color " and drinks " drink ".")))

(map about people)
