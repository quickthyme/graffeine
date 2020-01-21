# ![Graffeine](docs/icon.png) Graffeine

![release_version](https://img.shields.io/github/tag/quickthyme/graffeine.svg?label=release)
[![Build Status](https://travis-ci.com/quickthyme/graffeine.svg?branch=master)](https://travis-ci.com/quickthyme/graffeine)
![license](https://img.shields.io/github/license/quickthyme/graffeine.svg?color=black)

**Graffeine** /'gra•feen/ - *n* - Simple, declarative graphs for iOS.

## Introduction

![sample_1](docs/sample_1.png)

It's like, graphing... with caffeine.

Graffeine is an iOS library that uses CoreAnimation to render various types of data graphs and charts. It is highly extendable and features a declarative interface, multiple layers, configuration binding, and auto-layout.

<br />


## Pieces and Parts


### GraffeineView

Subclass of UIView that manages and provides the rendering context for the various graphing layers, which are divided into 5 *regions*:

               Top Gutter
            +---------------+
    Left    |     Main      | Right
    Gutter  |     Region    | Gutter
            +---------------+
              Bottom Gutter


Whenever a layer exists belonging to one of the regions, its positioning and size will automatically be managed by the view, which includes responding to layout changes or resizing events.

By default, `GraffeineView` contains no layers. You must add layers to it by setting the `layers` property, like so:

    graffeineView.layers = [
            GraffeineHorizontalLabelLayer(id: "top", height: 16, region: .topGutter),
            
            GraffeineHorizontalLabelLayer(id: "bottom", height: 26, region: .bottomGutter),
            
            GraffeineBarLayer(id: "bars")
                .apply ({
                    $0.unitMargin = 5
                    $0.colors = [.blue, .orange]
                })
        ]



<br />


### GraffeineLayer 

*(abstract)* Container-like "graphing layer" used to represent a particular graph component. By combining layers, you can dial in exactly the layout you want and render amazing graphs.

Out of the box, there are a handful of ready-to-go graphing layers:

| GraffeineLayer                   | Displays                        |
|----------------------------------|---------------------------------|
| `GraffeineBarLayer`              |   vertical or horizontal bars   |
| `GraffeineGridLineLayer`         |   horizontal or vertical lines  |
| `GraffeineHorizontalLabelLayer`  |   labels arranged horizontally  |
| `GraffeineVerticalLabelLayer`    |   labels arranged vertically    |
| `GraffeineRadialLabelLayer`      |   labels arranged circularly    |
| `GraffeineLineLayer`             |   bezier line connecting data   |
| `GraffeinePieLayer`              |   segmented pies and donuts     |
| `GraffeinePlotLayer`             |   individual plots (points)     |

When constructing a `GraffeineLayer`, you typically provide it with an `id` and a `region`.


##### id

The id is used to identify and access the layer after it has been added to a `GraffeineView`:

    let pieLayer = graffeineView.layer(id: "pie")


##### region

You can use any layer with any region, although some are more intended for certain
regions than others. For example, the horizontal and vertical label layers are generally
intended to be placed in one of the gutter regions.

<br />


## Interaction

### Setting Data

`GraffeineData` is the vehicle with which to pass data into Graffeine.
It's easy to apply new data to a specific layer by **assignment**:

    graffeineView.layer(id: "pie")?.data = GraffeineData(valueMax: 100, values: [1, 1, 2, 3, 5, 8, 13, 21, 34])
                                             
Or if you want it to **animate** whenever the data changes:

    graffeineView.layer(id: "pie")?
        .setData(GraffeineData(valueMax: 100, values: [1, 1, 2, 3, 5, 8, 13, 21, 34]), 
                 animator: GraffeineDataAnimators.Pie.Spin(duration: 1.2,
                                                           timing: .easeInEaseOut))

*There are a handful of data animators included with the library, out-of-box, or you can
create your own, so long as it conforms to `GraffeineDataAnimating`.*

<br />


### Showing Value Labels

Out-of-the-box, there are three label options: horizontal, vertical, and radial.


##### Horizontal and Vertical Labels

![sample_2](docs/sample_6.png)

Both `GraffeineHorizontalLabelLayer` and `GraffeineVerticalLabelLayer` are designed to
be used in the gutter region, where they can be configured to align with the units
displayed in the main region. This is important for things like bar and line charts,
where the labels need to line up exactly with the grid.

When using the horizontal or vertical label layers, you can choose how their unit
alignment gets distributed. Their horizontal/vertical label alignment properties
are relative to the unit, or column-width in which they are bound. So setting a label
to be `.center` means it will center itself **to the column**. Setting
`.centerLeftRight` will cause the first and last labels to be left/right aligned,
but all other labels will be centered.


##### Radial Labels

![sample_6](docs/sample_6.png)

The `GraffeineRadialLabelLayer` is primarily designed to be used in conjunction with
pie and donut charts, although they do work independently. For all intents and
purposes, positioning labels in the radial label layer works just like positioning
the pie slices.

<br />


### Handling Selection Events

Selection in Graffeine is ~~MIA~~ *WIP*, but it does currently invoke an `onSelect`
handler when the view receives a touch interaction. This is rudimentary at best, but
will eventually be expanded upon to be more useful.

<br />


### Demo App

There is an iOS app,
*[graffeine-demo](https://github.com/quickthyme/graffeine-demo)*,
which demonstrates how to quickly go about composing many typical types of graphs. If
nothing else, it serves as an example of how to plug the library in and turn it on.

<br />
