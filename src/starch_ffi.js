/**
 * JavaScript FFI layer for starch.
 *
 * Converts Gleam runtime values (singly-linked Lists, Option variants,
 * custom-type Position variants) to the plain JavaScript objects the
 * chart constructors expect, then delegates to those constructors.
 *
 * The chart classes (Bar, Line, …) depend on d3-* npm packages.
 * The consumer application must run this code through a bundler
 * (Vite, esbuild, webpack, …) that resolves those dependencies.
 */

import Bar from './js/Bar.js';
import Heatmap from './js/Heatmap.js';
import Line from './js/Line.js';
import Pie from './js/Pie.js';
import Radar from './js/Radar.js';
import Scatter from './js/Scatter.js';
import StackedBar from './js/StackedBar.js';

// After `gleam build --target javascript` the Gleam prelude is one
// directory above each package's compiled output.
import { Ok, Error as GleamError } from '../gleam.mjs';

// ---------------------------------------------------------------------------
// Runtime type conversion helpers
// ---------------------------------------------------------------------------

/**
 * Unwrap a Gleam Option to a JS value.
 * Gleam compiles Some(x) with its payload at the numeric property 0;
 * None has no such property.
 */
function fromOption(opt) {
  return (opt != null && Object.prototype.hasOwnProperty.call(opt, 0))
    ? opt[0]
    : null;
}

/**
 * Walk a Gleam singly-linked List (NonEmpty nodes carry .head and .tail)
 * and return a plain JS array.
 */
function listToArray(list) {
  const result = [];
  let node = list;
  while (node != null && Object.prototype.hasOwnProperty.call(node, 'head')) {
    result.push(node.head);
    node = node.tail;
  }
  return result;
}

/**
 * Map a Gleam Position variant to the integer expected by config.positionType.
 *   UpLeft → 1  UpRight → 2  DownLeft → 3  DownRight → 4
 */
function toPositionInt(pos) {
  const map = { UpLeft: 1, UpRight: 2, DownLeft: 3, DownRight: 4 };
  const name = pos && pos.constructor ? pos.constructor.name : 'UpLeft';
  return map[name] ?? 1;
}

/**
 * Convert a Gleam Dataset record to a plain JS dataset object.
 * Dataset has fields `label: String` and `data: List(Float)`.
 */
function convertDataset(ds) {
  return { label: ds.label, data: listToArray(ds.data) };
}

/**
 * Convert a Gleam ScatterDataset record to a plain JS dataset object.
 * ScatterDataset has fields `label: String` and `data: List(Point)`.
 * Point records have named fields `x` and `y`, which are preserved as-is.
 */
function convertScatterDataset(ds) {
  return { label: ds.label, data: listToArray(ds.data) };
}

// ---------------------------------------------------------------------------
// Exported chart functions (called via @external from starch.gleam)
// ---------------------------------------------------------------------------

export function bar(svg, labels, datasets, options) {
  return new Bar(svg, {
    title: fromOption(options.title) || undefined,
    xLabel: fromOption(options.x_label) || undefined,
    yLabel: fromOption(options.y_label) || undefined,
    data: {
      labels: listToArray(labels),
      datasets: listToArray(datasets).map(convertDataset),
    },
    options: {
      grouped: options.grouped,
      yMin: fromOption(options.y_min),
      yMax: fromOption(options.y_max),
    },
  });
}

export function line(svg, labels, datasets, options) {
  return new Line(svg, {
    title: fromOption(options.title) || undefined,
    xLabel: fromOption(options.x_label) || undefined,
    yLabel: fromOption(options.y_label) || undefined,
    data: {
      labels: listToArray(labels),
      datasets: listToArray(datasets).map(convertDataset),
    },
    options: {
      showArea: options.show_area,
      showLegend: options.show_legend,
      legendPosition: toPositionInt(options.legend_position),
      yMin: fromOption(options.y_min),
      yMax: fromOption(options.y_max),
    },
  });
}

export function pie(svg, labels, datasets, options) {
  return new Pie(svg, {
    title: fromOption(options.title) || undefined,
    data: {
      labels: listToArray(labels),
      datasets: listToArray(datasets).map(convertDataset),
    },
    options: {
      innerRadius: options.inner_radius,
      showLegend: options.show_legend,
      legendPosition: toPositionInt(options.legend_position),
    },
  });
}

export function scatter(svg, datasets, options) {
  return new Scatter(svg, {
    title: fromOption(options.title) || undefined,
    xLabel: fromOption(options.x_label) || undefined,
    yLabel: fromOption(options.y_label) || undefined,
    data: {
      datasets: listToArray(datasets).map(convertScatterDataset),
    },
    options: {
      dotSize: options.dot_size,
      showLine: options.show_line,
      showLegend: options.show_legend,
      legendPosition: toPositionInt(options.legend_position),
      xMin: fromOption(options.x_min),
      xMax: fromOption(options.x_max),
      yMin: fromOption(options.y_min),
      yMax: fromOption(options.y_max),
    },
  });
}

export function radar(svg, labels, datasets, options) {
  return new Radar(svg, {
    title: fromOption(options.title) || undefined,
    data: {
      labels: listToArray(labels),
      datasets: listToArray(datasets).map(convertDataset),
    },
    options: {
      showLabels: options.show_labels,
      ticksCount: options.ticks_count,
      dotSize: options.dot_size,
      showLegend: options.show_legend,
      legendPosition: toPositionInt(options.legend_position),
    },
  });
}

export function stackedBar(svg, labels, datasets, options) {
  return new StackedBar(svg, {
    title: fromOption(options.title) || undefined,
    xLabel: fromOption(options.x_label) || undefined,
    yLabel: fromOption(options.y_label) || undefined,
    data: {
      labels: listToArray(labels),
      datasets: listToArray(datasets).map(convertDataset),
    },
    options: {
      normalize: options.normalize,
      showLegend: options.show_legend,
      legendPosition: toPositionInt(options.legend_position),
      yMin: fromOption(options.y_min),
      yMax: fromOption(options.y_max),
    },
  });
}

export function heatmap(svg, labels, yLabels, data, options) {
  return new Heatmap(svg, {
    title: fromOption(options.title) || undefined,
    xLabel: fromOption(options.x_label) || undefined,
    yLabel: fromOption(options.y_label) || undefined,
    data: {
      labels: listToArray(labels),
      yLabels: listToArray(yLabels),
      datasets: [{ data: listToArray(data).map(listToArray) }],
    },
    options: {
      cellPadding: options.cell_padding,
      minOpacity: options.min_opacity,
      maxOpacity: options.max_opacity,
    },
  });
}

/**
 * Find an SVG element in the document by CSS selector.
 * Returns Ok(element) or Error(Nil) in Gleam Result form.
 */
export function querySvg(selector) {
  const el = document.querySelector(selector);
  return el != null ? new Ok(el) : new GleamError(undefined);
}
