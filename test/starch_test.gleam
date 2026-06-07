import gleeunit
import gleam/option
import starch.{BarOptions, Dataset, Point, ScatterDataset, UpLeft}

pub fn main() -> Nil {
  gleeunit.main()
}

// These tests verify that the Gleam types and default constructors are
// well-formed.  The chart rendering functions themselves call JavaScript FFI
// and cannot be exercised under gleeunit's Erlang target.

pub fn default_bar_options_test() {
  let opts = starch.default_bar_options()
  assert opts.grouped == False
  assert opts.title == option.None
  assert opts.y_min == option.None
  assert opts.y_max == option.None
}

pub fn default_line_options_test() {
  let opts = starch.default_line_options()
  assert opts.show_area == False
  assert opts.show_legend == True
  assert opts.legend_position == UpLeft
}

pub fn default_pie_options_test() {
  let opts = starch.default_pie_options()
  assert opts.inner_radius == 0.5
  assert opts.show_legend == True
}

pub fn default_scatter_options_test() {
  let opts = starch.default_scatter_options()
  assert opts.dot_size == 1.0
  assert opts.show_line == False
  assert opts.x_min == option.None
}

pub fn default_radar_options_test() {
  let opts = starch.default_radar_options()
  assert opts.ticks_count == 3
  assert opts.show_labels == False
  assert opts.show_legend == False
}

pub fn default_stacked_bar_options_test() {
  let opts = starch.default_stacked_bar_options()
  assert opts.normalize == False
  assert opts.show_legend == True
}

pub fn default_heatmap_options_test() {
  let opts = starch.default_heatmap_options()
  assert opts.cell_padding == 0.05
  assert opts.min_opacity == 0.08
  assert opts.max_opacity == 0.92
}

pub fn dataset_fields_test() {
  let ds = Dataset(label: "series", data: [1.0, 2.0, 3.0])
  assert ds.label == "series"
}

pub fn scatter_dataset_fields_test() {
  let ds = ScatterDataset(label: "pts", data: [Point(x: 1.0, y: 2.0)])
  assert ds.label == "pts"
}

pub fn override_bar_options_test() {
  let opts =
    BarOptions(
      ..starch.default_bar_options(),
      grouped: True,
      title: option.Some("My Chart"),
    )
  assert opts.grouped == True
  assert opts.title == option.Some("My Chart")
  assert opts.y_min == option.None
}

pub fn position_variants_test() {
  // Confirm at least one position variant can be used as a value.
  let _pos = UpLeft
  Nil
}
