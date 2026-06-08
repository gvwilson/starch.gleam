# Contributing to starch

## Project layout

```
gleam.toml              Package metadata
src/
  starch.gleam          Public Gleam API: types, default constructors, @external
  starch_ffi.js         FFI glue: converts Gleam runtime values to JS objects,
                        then calls chart constructors
  js/                   Chart JavaScript source (derived from chart.xkcd)
    Bar.js etc.         Chart implementations
    config.js           Shared constants
    utils/
      Tooltip.js etc.   Helpers
test/
  starch_test.gleam     Pure-Gleam unit tests
example/
  gleam.toml            Example app (depends on starch via path = "..")
  src/app.gleam         Gleam entry point — one call per chart type
  entry.js              Thin JS shim: imports compiled app.mjs and calls main()
  index.html            Demo page — seven SVG containers
```

## Running checks

```sh
gleam deps download    # install Gleam dependencies (run from project root)
gleam test             # Gleam type and default-value tests
gleam format           # format Gleam source

npm install            # install JS dependencies (d3, vite)
npm run dev            # compile example Gleam + start Vite at http://localhost:5173
npm run build          # compile example Gleam + bundle to example/dist/
```

`npm run dev` and `npm run build` both run
`cd example && gleam build --target javascript` first, then invoke Vite.

## Adding a new chart type

1. Add the JS source file to `src/js/`.
2. Import it in `starch_ffi.js` and add an exported wrapper function that
   converts Gleam runtime types (linked List, Option, Position) to plain JS.
3. Add a Gleam options type, a `default_*_options()` function, and a
   `@target(javascript) @external(javascript, …)` declaration in `starch.gleam`.
4. Add a call with a few data points to `example/src/app.gleam`.
5. Add default-options and field tests in `test/starch_test.gleam`.

## Key conventions

-   **No labelled arguments on `@external` calls.** Gleam supports labelled
    arguments on regular functions but not on `@external` ones. Call
    `starch.bar(svg, labels, datasets, options)` positionally. Record
    constructors (`Dataset(label: …, data: …)`) and record-update syntax
    (`BarOptions(..default, title: …)`) still use labels as normal.

-   **Gleam field names are snake_case in JS.** Gleam compiles record fields
    with their original names, so `starch_ffi.js` reads `options.y_min`,
    `options.x_label`, etc.

-   **Gleam List → JS array.** `starch_ffi.js` converts with `listToArray`
    before passing to chart constructors.

-   **Gleam Option → nullable.** `Some(x)` stores its payload at `opt[0]`;
    `None` has no such property. `starch_ffi.js` converts with `fromOption`.

-   **Position variants → integers.** `UpLeft=1, UpRight=2, DownLeft=3,
    DownRight=4` via `toPositionInt` in `starch_ffi.js`.

-   **d3-selection must stay at `^1.4.1`.** The chart JS files use `mouse`
    and `event`, which were removed in d3-selection v2.

-   **Do not modify files in `src/js/`.** They are derived from the upstream
    [chart.xkcd](https://github.com/timqian/chart.xkcd) project. Fixes that
    apply upstream should be submitted there first.
