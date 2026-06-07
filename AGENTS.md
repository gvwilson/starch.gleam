# Starch — Agent Guide

## What this project is

Starch is a Gleam library that wraps xkcd-style SVG charts for use in browser
applications.  It targets the **JavaScript** compilation target only.  There is
no Erlang/BEAM implementation of any chart function.

The library ships seven chart types (Bar, Line, Pie, Scatter, Radar,
StackedBar, Heatmap) implemented in JavaScript and exposed to Gleam through a
thin FFI layer.

## Layout

```
gleam.toml              Package metadata
src/
  starch.gleam          Public Gleam API: types, default constructors, @external
  starch_ffi.js         FFI glue: converts Gleam runtime values → JS objects,
                        then calls chart constructors
  js/                   Chart JavaScript source (copied from chart.xkcd project)
    Bar.js Line.js Pie.js Radar.js Scatter.js StackedBar.js Heatmap.js
    config.js           Shared chart constants
    index.js            Standalone entry point (CJS; not used by starch_ffi.js)
    components/
      Tooltip.js
    utils/
      addAxis.js addFilter.js addFont.js addLabels.js addLegend.js
      colors.js fontData.js initChart.js
test/
  starch_test.gleam     Pure-Gleam unit tests (types, defaults, record fields)
```

## Commands

```sh
gleam deps download    # install dependencies
gleam build            # compile (reports type errors in starch.gleam)
gleam test             # run gleeunit tests (Erlang target; pure-Gleam tests only)
gleam format           # format all Gleam source
gleam build --target javascript   # compile to JS for inspection
```

## Key conventions

- **One `@external` per chart function.**  Each public chart function in
  `starch.gleam` has a matching export in `starch_ffi.js`.  Keep them in sync.

- **Gleam field names stay snake_case in JS.**  Gleam compiles record fields
  with their original names.  `starch_ffi.js` therefore reads `options.y_min`,
  `options.x_label`, etc. — not camelCase.

- **Gleam List → JS array.**  Gleam's `List(a)` is a singly-linked list at
  runtime.  `starch_ffi.js` converts it with `listToArray` before passing to
  the chart constructors.

- **Gleam Option → nullable.**  `Some(x)` stores its payload at `opt[0]`;
  `None` has no such property.  `starch_ffi.js` converts with `fromOption`.

- **Position variants → integers.**  The `Position` custom type maps to
  `config.positionType` integers (UpLeft=1, UpRight=2, DownLeft=3, DownRight=4)
  via `toPositionInt`.

- **d3 must be bundled by the consumer.**  The chart JS files import from
  `d3-selection`, `d3-scale`, `d3-shape`, and `dayjs`.  Users must run the
  compiled output through Vite, esbuild, or webpack.  Do not add bundling to
  this package.

- **Do not copy or import `widget.js`.**  That file is an anywidget adapter
  for marimo notebooks and has no role in Gleam.

- **Do not modify the JS chart source files in `src/js/`.**  They are copied
  verbatim from the upstream chart.xkcd project.  Fixes belong upstream.

## Adding a new chart type

1. Add the JS source file to `src/js/`.
2. Import it in `starch_ffi.js` and add an exported wrapper function.
3. Add a Gleam options type, a `default_*_options()` function, and an
   `@external` declaration in `starch.gleam`.
4. Add default-options and field tests in `test/starch_test.gleam`.
