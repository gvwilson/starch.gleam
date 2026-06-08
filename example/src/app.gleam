import gleam/option
import starch

pub fn main() -> Nil {
  bar()
  line()
  pie()
  scatter()
  radar()
  stacked_bar()
  heatmap()
}

fn get(id: String) -> starch.SvgElement {
  let assert Ok(el) = starch.query_svg(id)
  el
}

fn bar() -> Nil {
  starch.bar(
    get("#chart-bar"),
    ["Spring", "Summer", "Autumn", "Winter"],
    [starch.Dataset(label: "Apples", data: [12.0, 28.0, 42.0, 8.0])],
    starch.BarOptions(
      ..starch.default_bar_options(),
      title: option.Some("Fruit harvest by season"),
      x_label: option.Some("Season"),
      y_label: option.Some("Kilograms"),
    ),
  )
}

fn line() -> Nil {
  starch.line(
    get("#chart-line"),
    ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
    [
      starch.Dataset(label: "High", data: [4.0, 6.0, 10.0, 15.0, 20.0, 24.0]),
      starch.Dataset(label: "Low", data: [-2.0, -1.0, 2.0, 6.0, 11.0, 14.0]),
    ],
    starch.LineOptions(
      ..starch.default_line_options(),
      title: option.Some("Monthly temperature (°C)"),
      x_label: option.Some("Month"),
      y_label: option.Some("Temp"),
      show_area: True,
    ),
  )
}

fn pie() -> Nil {
  starch.pie(
    get("#chart-pie"),
    ["Gleam", "Elm", "PureScript", "Other"],
    [starch.Dataset(label: "", data: [38.0, 27.0, 19.0, 16.0])],
    starch.PieOptions(
      ..starch.default_pie_options(),
      title: option.Some("Language popularity"),
      inner_radius: 0.0,
    ),
  )
}

fn scatter() -> Nil {
  starch.scatter(
    get("#chart-scatter"),
    [
      starch.ScatterDataset(
        label: "Group A",
        data: [
          starch.Point(x: 162.0, y: 58.0),
          starch.Point(x: 168.0, y: 64.0),
          starch.Point(x: 174.0, y: 70.0),
          starch.Point(x: 180.0, y: 76.0),
        ],
      ),
      starch.ScatterDataset(
        label: "Group B",
        data: [
          starch.Point(x: 158.0, y: 52.0),
          starch.Point(x: 165.0, y: 60.0),
          starch.Point(x: 172.0, y: 68.0),
          starch.Point(x: 178.0, y: 73.0),
        ],
      ),
    ],
    starch.ScatterOptions(
      ..starch.default_scatter_options(),
      title: option.Some("Height vs weight"),
      x_label: option.Some("Height (cm)"),
      y_label: option.Some("Weight (kg)"),
    ),
  )
}

fn radar() -> Nil {
  starch.radar(
    get("#chart-radar"),
    ["Speed", "Safety", "Comfort", "Economy", "Range"],
    [
      starch.Dataset(label: "Car A", data: [85.0, 70.0, 65.0, 50.0, 80.0]),
      starch.Dataset(label: "Car B", data: [55.0, 85.0, 80.0, 90.0, 60.0]),
    ],
    starch.RadarOptions(
      ..starch.default_radar_options(),
      title: option.Some("Vehicle comparison"),
      show_labels: True,
      show_legend: True,
    ),
  )
}

fn stacked_bar() -> Nil {
  starch.stacked_bar(
    get("#chart-stacked-bar"),
    ["Q1", "Q2", "Q3", "Q4"],
    [
      starch.Dataset(label: "North", data: [15.0, 22.0, 19.0, 28.0]),
      starch.Dataset(label: "South", data: [12.0, 16.0, 24.0, 20.0]),
    ],
    starch.StackedBarOptions(
      ..starch.default_stacked_bar_options(),
      title: option.Some("Quarterly sales by region"),
      x_label: option.Some("Quarter"),
      y_label: option.Some("Units"),
    ),
  )
}

fn heatmap() -> Nil {
  starch.heatmap(
    get("#chart-heatmap"),
    ["Mon", "Tue", "Wed", "Thu", "Fri"],
    ["Morning", "Afternoon", "Evening"],
    [
      [10.0, 15.0, 12.0, 8.0, 20.0],
      [25.0, 30.0, 18.0, 22.0, 15.0],
      [5.0, 8.0, 12.0, 10.0, 6.0],
    ],
    starch.HeatmapOptions(
      ..starch.default_heatmap_options(),
      title: option.Some("Activity levels by day and time"),
      x_label: option.Some("Day"),
      y_label: option.Some("Time of day"),
    ),
  )
}
