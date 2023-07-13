#!/usr/bin/env coffee

people = [
  name: 'Ingy'
  favs: ['coffee', 'yellow']
,
  name: 'Gugod'
  favs: ['tea', 'blue']
]

for person in people
  {
    name,
    favs: [
      drink,
      color
    ]
  } = person

  console.log "#{name} wears #{color} and drinks #{drink}."
