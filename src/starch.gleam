//// Starch — xkcd-style charts for Gleam (JavaScript target only).
////
//// Each chart function accepts a target SVG element, chart data, and an
//// options record. Obtain an SVG element with `query_svg` or via your own
//// JavaScript FFI. All rendering happens in the browser; this module has
//// no Erlang implementation.
////
//// The underlying JavaScript classes depend on the d3 family of npm
//// packages. The consuming application must bundle this output with a
//// tool such as Vite or esbuild that resolves those dependencies.

import gleam/option.{type Option}

// ── Foreign type ─────────────────────────────────────────────────────────────

/// An SVG DOM element. Obtain one with `query_svg` or from your own FFI.
pub type SvgElement

// ── Shared data types ─────────────────────────────────────────────────────────

/// A single dataset for bar, line, radar, and stacked-bar charts.
pub type Dataset {
  Dataset(label: String, data: List(Float))
}

/// An (x, y) point for scatter charts.
pub type Point {
  Point(x: Float, y: Float)
}

/// A dataset for scatter charts.
pub type ScatterDataset {
  ScatterDataset(label: String, data: List(Point))
}

/// Legend and tooltip placement.
pub type Position {
  UpLeft
  UpRight
  DownLeft
  DownRight
}

// ── Bar ───────────────────────────────────────────────────────────────────────

pub type BarOptions {
  BarOptions(
    title: Option(String),
    x_label: Option(String),
    y_label: Option(String),
    grouped: Bool,
    y_min: Option(Float),
    y_max: Option(Float),
  )
}

pub fn default_bar_options() -> BarOptions {
  BarOptions(
    title: option.None,
    x_label: option.None,
    y_label: option.None,
    grouped: False,
    y_min: option.None,
    y_max: option.None,
  )
}

@target(javascript)
@external(javascript, "./starch_ffi.js", "bar")
pub fn bar(
  svg: SvgElement,
  labels: List(String),
  datasets: List(Dataset),
  options: BarOptions,
) -> Nil

// ── Line ──────────────────────────────────────────────────────────────────────

pub type LineOptions {
  LineOptions(
    title: Option(String),
    x_label: Option(String),
    y_label: Option(String),
    show_area: Bool,
    show_legend: Bool,
    legend_position: Position,
    y_min: Option(Float),
    y_max: Option(Float),
  )
}

pub fn default_line_options() -> LineOptions {
  LineOptions(
    title: option.None,
    x_label: option.None,
    y_label: option.None,
    show_area: False,
    show_legend: True,
    legend_position: UpLeft,
    y_min: option.None,
    y_max: option.None,
  )
}

@target(javascript)
@external(javascript, "./starch_ffi.js", "line")
pub fn line(
  svg: SvgElement,
  labels: List(String),
  datasets: List(Dataset),
  options: LineOptions,
) -> Nil

// ── Pie ───────────────────────────────────────────────────────────────────────

pub type PieOptions {
  PieOptions(
    title: Option(String),
    inner_radius: Float,
    show_legend: Bool,
    legend_position: Position,
  )
}

pub fn default_pie_options() -> PieOptions {
  PieOptions(
    title: option.None,
    inner_radius: 0.5,
    show_legend: True,
    legend_position: UpLeft,
  )
}

@target(javascript)
@external(javascript, "./starch_ffi.js", "pie")
pub fn pie(
  svg: SvgElement,
  labels: List(String),
  datasets: List(Dataset),
  options: PieOptions,
) -> Nil

// ── Scatter ───────────────────────────────────────────────────────────────────

pub type ScatterOptions {
  ScatterOptions(
    title: Option(String),
    x_label: Option(String),
    y_label: Option(String),
    dot_size: Float,
    show_line: Bool,
    show_legend: Bool,
    legend_position: Position,
    x_min: Option(Float),
    x_max: Option(Float),
    y_min: Option(Float),
    y_max: Option(Float),
  )
}

pub fn default_scatter_options() -> ScatterOptions {
  ScatterOptions(
    title: option.None,
    x_label: option.None,
    y_label: option.None,
    dot_size: 1.0,
    show_line: False,
    show_legend: True,
    legend_position: UpLeft,
    x_min: option.None,
    x_max: option.None,
    y_min: option.None,
    y_max: option.None,
  )
}

@target(javascript)
@external(javascript, "./starch_ffi.js", "scatter")
pub fn scatter(
  svg: SvgElement,
  datasets: List(ScatterDataset),
  options: ScatterOptions,
) -> Nil

// ── Radar ─────────────────────────────────────────────────────────────────────

pub type RadarOptions {
  RadarOptions(
    title: Option(String),
    show_labels: Bool,
    ticks_count: Int,
    dot_size: Float,
    show_legend: Bool,
    legend_position: Position,
  )
}

pub fn default_radar_options() -> RadarOptions {
  RadarOptions(
    title: option.None,
    show_labels: False,
    ticks_count: 3,
    dot_size: 1.0,
    show_legend: False,
    legend_position: UpLeft,
  )
}

@target(javascript)
@external(javascript, "./starch_ffi.js", "radar")
pub fn radar(
  svg: SvgElement,
  labels: List(String),
  datasets: List(Dataset),
  options: RadarOptions,
) -> Nil

// ── StackedBar ────────────────────────────────────────────────────────────────

pub type StackedBarOptions {
  StackedBarOptions(
    title: Option(String),
    x_label: Option(String),
    y_label: Option(String),
    normalize: Bool,
    show_legend: Bool,
    legend_position: Position,
    y_min: Option(Float),
    y_max: Option(Float),
  )
}

pub fn default_stacked_bar_options() -> StackedBarOptions {
  StackedBarOptions(
    title: option.None,
    x_label: option.None,
    y_label: option.None,
    normalize: False,
    show_legend: True,
    legend_position: UpLeft,
    y_min: option.None,
    y_max: option.None,
  )
}

@target(javascript)
@external(javascript, "./starch_ffi.js", "stackedBar")
pub fn stacked_bar(
  svg: SvgElement,
  labels: List(String),
  datasets: List(Dataset),
  options: StackedBarOptions,
) -> Nil

// ── Heatmap ───────────────────────────────────────────────────────────────────

pub type HeatmapOptions {
  HeatmapOptions(
    title: Option(String),
    x_label: Option(String),
    y_label: Option(String),
    cell_padding: Float,
    min_opacity: Float,
    max_opacity: Float,
  )
}

pub fn default_heatmap_options() -> HeatmapOptions {
  HeatmapOptions(
    title: option.None,
    x_label: option.None,
    y_label: option.None,
    cell_padding: 0.05,
    min_opacity: 0.08,
    max_opacity: 0.92,
  )
}

@target(javascript)
@external(javascript, "./starch_ffi.js", "heatmap")
pub fn heatmap(
  svg: SvgElement,
  labels: List(String),
  y_labels: List(String),
  data: List(List(Float)),
  options: HeatmapOptions,
) -> Nil

// ── Utility ───────────────────────────────────────────────────────────────────

/// Find an SVG element in the document by CSS selector.
/// Returns `Error(Nil)` when no matching element exists.
@target(javascript)
@external(javascript, "./starch_ffi.js", "querySvg")
pub fn query_svg(selector: String) -> Result(SvgElement, Nil)
