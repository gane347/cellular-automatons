# Cellular automatons

A cellular automaton is a grid of cells, where each cell can have a set number of states. By stepping forward in time a new grid of cells is created. Each automaton has a specific set of rules.

# How to run

It is much simpler to understand the concept of cellular automatons with an interactive tool. This repository contains this tool created with Godot and is hosted [here](https://gane347.github.io/cellular-automatons/). It was created to gain a bit of knowledge in the topic and to try out Godot as an engine.

# Rules

## Conway's Game of Life

This automaton uses a Moore neighbourhood, as do most of the rules in this repo (except Rule 90 and Rule 184), meaning it checks eight cells around the main cell. 

In each generation:

- A cell is born if it has 3 neighbours

- A cell dies if it has fewer than 2 or more than 3 neighbours



There are various patterns I recommend to try out:

**Oscillators:**

|Blinker |Toad |Pulsar |
|---|---|---|
|![blinker](https://github.com/gane347/cellular-automatons/blob/main/Docs/blinker.png?raw=true)|![toad](https://github.com/gane347/cellular-automatons/blob/main/Docs/toad.png?raw=true)|![pulsar](https://github.com/gane347/cellular-automatons/blob/main/Docs/pulsar.png?raw=true)|

**Spaceships:**

|Glider |Light-weight spaceship (LWSS)|Middle-weight spaceship (MWSS)|
|---|---|---|
|![glider](https://github.com/gane347/cellular-automatons/blob/main/Docs/glider.png?raw=true)|![lwss](https://github.com/gane347/cellular-automatons/blob/main/Docs/lwss.png?raw=true)|![mwss](https://github.com/gane347/cellular-automatons/blob/main/Docs/mwss.png?raw=true)|



## Seeds

In each generation:

- A living cell dies

- A dead cell becomes a living cell if it has exactly 2 neighbours



This automaton is very chaotic and often fills the whole screen



## Brian's Brain

Brian's brain is quite similar to Seeds, but it has 3 states -- living, dying or dead.

In each generation:

- A living cell becomes a dying cell

- A dying cell becomes a dead cell

- A dead cell becomes a living cell if it has exactly 2 neighbours



This automaton is much more stable than Seeds and some "structures" emerge, such as gliders and rakes.

## Day and Night

In each generation:

- A living cell becomes a dead cell if it has 0, 1, 2 or 5 living neighbours

- A dead cell becomes a living cell if it has 3, 6, 7, or 8 living neighbours



As the generation go on, a pattern seems to emerge -- white and black cells separate into regions.

![Day and Night after 100 generations](https://github.com/gane347/cellular-automatons/blob/main/Docs/day\_and\_night.png?raw=true)

## Rule 90

Rule 90 and Rule 184 are one-dimensional automatons, but to visualize how they change - the y axis was turned into time. Each generation modifies the previous row. Rule 90 works by using a XOR on each cells neighbours.

In each generation:

- If the left and right neighbours are different, the cell is alive

- If the left and right neighbours are the same, the cell is dead



If only one cell is alive, the following generations produce a Sierpiński triangle.

![Sierpinski triangle](https://github.com/gane347/cellular-automatons/blob/main/Docs/sierpinski\_triangle.png?raw=true)

## Rule 184

In each generation:

- If a pattern has a 1 followed by a 0, they switch places

|Current pattern          |111|110|101|100|011|010|001|000|
|-------------------------|---|---|---|---|---|---|---|---|
|new state for center cell| 1 | 0 | 1 | 1 | 1 | 0 | 0 | 0 |



# Read More

[Cellular Automaton on Wikipedia](https://en.wikipedia.org/wiki/Cellular\_automaton)

[Conway's Game of Life on Wikipedia](https://en.wikipedia.org/wiki/Conway%27s\_Game\_of\_Life)

[Brian's Brain on Wikipedia](https://en.wikipedia.org/wiki/Brian%27s\_Brain)

[Seeds on Wikipedia](https://en.wikipedia.org/wiki/Seeds\_(cellular\_automaton))

[Day and Night on Wikipedia](https://en.wikipedia.org/wiki/Day\_and\_Night\_(cellular\_automaton))

[Rule 90 on Wikipedia](https://en.wikipedia.org/wiki/Rule\_90)

[Rule 184 on Wikipedia](https://en.wikipedia.org/wiki/Rule\_184)