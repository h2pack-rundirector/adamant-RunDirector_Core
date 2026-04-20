# Run Director Core

Core coordinator for the [Run Director modpack](https://github.com/h2pack-rundirector/run-director-modpack).

This package provides the shared Run Director window and the pack-level behavior that ties the Run Director modules together.

It owns:

- pack identity and coordinator bootstrap
- shared profile slots and default profile data
- module discovery and the combined Run Director settings UI
- the menu entry and main control surface for the full modpack

Players normally install this as part of the full Run Director pack, not as a standalone gameplay module.

## What Run Director Does

Run Director is a modular run-customization pack for Hades II. The current gameplay modules focus on three parts of a run:

- `BiomeControl`
  Shapes encounter composition inside each biome, including room timing, NPC timing, miniboss behavior, reward priorities, and biome-specific tweaks.
- `GodPool`
  Shapes the Olympian pool before individual boon filtering, including per-god toggles, max-god count, keepsake pool behavior, and first-room hammer support.
- `BoonBans`
  Filters individual boon offers across Olympians, other gods, hammers, NPCs, and keepsake-style sources, with padding and rarity controls.

Together, these modules let you steer:

- which Olympian sources are even allowed into the run
- which individual boons can still appear once a source is active
- how biomes pace out their special rooms, NPCs, minibosses, and reward structure

## Included Modules

- [BiomeControl](https://github.com/h2pack-rundirector/adamant-RunDirector_BiomeControl)
- [GodPool](https://github.com/h2pack-rundirector/adamant-RunDirector_GodPool)
- [BoonBans](https://github.com/h2pack-rundirector/adamant-RunDirector_BoonBans)

## Installation

Install through the full [Run Director modpack](https://github.com/h2pack-rundirector/run-director-modpack) via r2modman or your preferred ReturnOfModding workflow.

## More Information

- [Run Director modpack shell repo](https://github.com/h2pack-rundirector/run-director-modpack)
- [Changelog](CHANGELOG.md)
