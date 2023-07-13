#!/usr/bin/env node

const people = [
  { name: 'Ingy', favs: ['coffee', 'yellow'] },
  { name: 'Gugod', favs: ['tea', 'blue'] },
];

people.forEach(({ name, favs: [ drink, color ] }) => {
  console.log(`${name} wears ${color} and drinks ${drink}.`);
});
