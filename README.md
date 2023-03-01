### disintegrator-stool
Remover STOOL but with some modifications

![icon](https://user-images.githubusercontent.com/71168720/222167618-40e38f4c-54c0-4986-8849-a45a77a1c7e0.gif)

## General info
# Why to download and use, if we have Remover?
Because it has more effects, ability for admins to dramatically kick player, and some little modifications for NPCs
Actually, why are you asking this question, if you are here. If you don't want this addon - just go to next, it does not worth your time.

# Does it has workshop page?
Yes, it has:
https://steamcommunity.com/sharedfiles/filedetails/?id=2940577632

## Contribution
# 1. If your pull-request modifies or adds new language...
...create `lang_(LANG_CODE).lua` file in lua/autorun.
This file should return one table with next keys:
  ["name"] - Localized name of a tool,
  ["desc"] - Localized description of a tool,
  ["left"] - Action on LBM - Delete selected object,
  ["right"] - Action on RBM - Delete selected and attached objects,
  ["reload"] - Action on reload - Delete all constraints of a selected object

# 2. If your pull-request changes code...
...make sure that it is readable and commented. it is not required, just makes reviewing/modifying easier
Before making big changes ask me - "can I do X?", "can i remove Y?", "can I rewrite Z?". In most cases answer will be yes, if this change will not break anything
