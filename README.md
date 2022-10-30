# Icon bundling comparison

_This repo is for [https://github.com/evanw/esbuild/issues/2641](https://github.com/evanw/esbuild/issues/2641)._

This demonstrates two different ways of structuring the `mdi-material-ui` package, which exports many thousands of icons both as individual files (`import Icon from 'mdi-material-ui/Icon'`) and as the primary entry point (`import { Icon } from 'mdi-material-ui'`). These two approaches have different effects on bundling time.

To run this demo, type `make` in this directory.

## Approach 1

The first approach is what `mdi-material-ui` currently does, which is to put the icons in the individual files (in CommonJS format) and re-export them from the primary entry point file (in ESM format). This makes importing a single icon the fastest but it makes importing the primary entry point the slowest:

|                 | esbuild | rollup | parcel | webpack |
|-----------------|---------|--------|--------|---------|
| Individual file | 0.35s   | 7.97s  | 7.05s  | 6.53s   |
| Entry point     | 1.54s   | 33.35s | 11.94s | 18.80s  |

## Approach 2

The second approach is to put the icons in the primary entry point file (in ESM format) and re-export them from the individual files (also in ESM format), which is only done for backward-compatibility with the first approach. This makes both styles of importing happen at about the same speed, which falls in the middle of the best-case and worst-case speeds of the first approach:

|                 | esbuild | rollup | parcel | webpack |
|-----------------|---------|--------|--------|---------|
| Individual file | 0.33s   | 9.13s  | 9.24s  | 10.82s  |
| Entry point     | 0.37s   | 9.34s  | 9.04s  | 10.86s  |

As a bonus, using ESM over CommonJS also results in universally smaller bundle sizes with every single bundler tested.

## Summary

The second approach slows down the individual file case while speeding up the entry point case, so it's a trade-off. Here are the bundling speeds from approach 1 compared with the bundling speeds from approach 2:

|                 | esbuild     | rollup       | parcel      | webpack     |
|-----------------|-------------|--------------|-------------|-------------|
| Individual file | Same        | 1.2s slower  | 2.2s slower | 4.3s slower |
| Entry point     | 1.2s faster | 24.0s faster | 2.9s faster | 7.9s faster |
