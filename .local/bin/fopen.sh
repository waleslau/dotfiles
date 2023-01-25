#!/bin/bash
cat-all.py | fzf | awk '{print $1}' | xargs xdg-open &> /dev/null
