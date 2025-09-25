---
title: "Wallpapers"
date: 2025-08-30
description: "High-res backgrounds from Colorado days — Flatirons at sunrise, alpine lakes, monsoon skies."
params:
  featured: true         # show on homepage
  sort_by: Name          # or "Date"
  sort_order: asc
resources:
  # Adjust these filenames to match what you've actually got in /content/wallpaper/
  - src: "flatirons-01.jpg"
    title: "Flatirons glow at sunrise"
  - src: "alpine-lake-01.jpg"
    title: "Mirror-calm alpine lake"
  - src: "storm-light-01.jpg"
    title: "Monsoon light over the Divide"
  - src: "flatirons-feature.jpg"
    params:
      cover: true        # use this as album cover
      hidden: true       # not shown inside the gallery grid
---