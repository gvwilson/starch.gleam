# starch

xkcd-style charts for [Gleam](https://gleam.run), targeting the JavaScript
platform.  Rendering is done by the
[chart.xkcd](https://github.com/timqian/chart.xkcd) JavaScript library (via
a local fork — see `src/js/`).

**JavaScript target only.**  There is no Erlang/BEAM implementation.

## Charts

| Function | Chart type |
|---|---|
| `bar` | Bar (single or grouped) |
| `line` | Line with optional area fill |
| `pie` | Pie / donut |
| `scatter` | Scatter / bubble |
| `radar` | Radar (spider) |
| `stacked_bar` | Stacked bar (optionally normalised to 100 %) |
| `heatmap` | Heatmap |

## Quick start

### 1. Add the package

```sh
gleam add starch
```

### 2. Install d3 in your JavaScript project

The chart classes depend on d3 packages.  In your application directory:

```sh
npm install d3-selection d3-scale d3-shape d3-axis dayjs
```

### 3. Bundle with Vite (or esbuild / webpack)

`gleam build --target javascript` produces ESM output in
`build/dev/javascript/`.  Point your bundler at the entry file that imports
from `starch`.

### 4. Write Gleam code

```gleam
import gleam/option
import starch

pub fn main() {
  let assert Ok(svg) = starch.query_svg("#my-chart")

  let datasets = [
    starch.Dataset(label: "Apples", data: [4.0, 6.0, 3.0, 8.0]),
    starch.Dataset(label: "Oranges", data: [2.0, 5.0, 7.0, 1.0]),
  ]

  starch.bar(
    svg,
    labels: ["Q1", "Q2", "Q3", "Q4"],
    datasets:,
    options: starch.BarOptions(
      ..starch.default_bar_options(),
      title: option.Some("Quarterly sales"),
    ),
  )
}
```

## Obtaining an SVG element

`starch.query_svg(selector)` searches the DOM and returns
`Result(SvgElement, Nil)`.  Alternatively, write your own FFI:

```javascript
// app_ffi.js
export function getChart() {
  return document.getElementById("chart");
}
```

```gleam
// app.gleam
@external(javascript, "./app_ffi.js", "getChart")
fn get_chart() -> starch.SvgElement
```

## Options records

Every chart type has a `default_*_options()` constructor.  Override only the
fields you need using Gleam's record-update syntax:

```gleam
starch.LineOptions(
  ..starch.default_line_options(),
  title: option.Some("Weekly samples"),
  show_area: True,
  legend_position: starch.DownRight,
)
```

### Common option fields

| Field | Type | Default | Applies to |
|---|---|---|---|
| `title` | `Option(String)` | `None` | all |
| `x_label` | `Option(String)` | `None` | bar, line, scatter, stacked_bar, heatmap |
| `y_label` | `Option(String)` | `None` | bar, line, scatter, stacked_bar, heatmap |
| `show_legend` | `Bool` | `True` | line, pie, scatter, stacked_bar |
| `legend_position` | `Position` | `UpLeft` | line, pie, scatter, radar, stacked_bar |
| `y_min` / `y_max` | `Option(Float)` | `None` | bar, line, scatter, stacked_bar |

### Position values

`UpLeft` · `UpRight` · `DownLeft` · `DownRight`

### Bar-specific options

| Field | Default |
|---|---|
| `grouped: Bool` | `False` |

### Line-specific options

| Field | Default |
|---|---|
| `show_area: Bool` | `False` |

### Pie-specific options

| Field | Default |
|---|---|
| `inner_radius: Float` | `0.5` (donut) — set to `0.0` for solid pie |

### Scatter-specific options

| Field | Default |
|---|---|
| `dot_size: Float` | `1.0` |
| `show_line: Bool` | `False` |
| `x_min` / `x_max` | `None` |

### Radar-specific options

| Field | Default |
|---|---|
| `show_labels: Bool` | `False` |
| `ticks_count: Int` | `3` |
| `dot_size: Float` | `1.0` |

### StackedBar-specific options

| Field | Default |
|---|---|
| `normalize: Bool` | `False` |

### Heatmap-specific options

| Field | Default |
|---|---|
| `cell_padding: Float` | `0.05` |
| `min_opacity: Float` | `0.08` |
| `max_opacity: Float` | `0.92` |

## Heatmap data shape

The heatmap function takes row and column labels separately plus a
`List(List(Float))` where each inner list is one row:

```gleam
starch.heatmap(
  svg,
  labels: ["Col A", "Col B", "Col C"],
  y_labels: ["Row 1", "Row 2"],
  data: [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]],
  options: starch.default_heatmap_options(),
)
```

## Scatter data shape

Scatter charts use `ScatterDataset` and `Point` instead of `Dataset`:

```gleam
starch.scatter(
  svg,
  datasets: [
    starch.ScatterDataset(
      label: "Group A",
      data: [starch.Point(x: 1.0, y: 2.0), starch.Point(x: 3.0, y: 4.0)],
    ),
  ],
  options: starch.default_scatter_options(),
)
```

## Development

```sh
gleam deps download
gleam test        # pure-Gleam type/default tests under Erlang target
gleam format
```
