# ![Graffeine](docs/icon.png) Graffeine

![release_version](https://img.shields.io/github/tag/quickthyme/graffeine.svg?label=release)
[![Build Status](https://travis-ci.com/quickthyme/graffeine.svg?branch=master)](https://travis-ci.com/quickthyme/graffeine)
![license](https://img.shields.io/github/license/quickthyme/graffeine.svg?color=black)

**Graffeine** /'gra•feen/ - *n* - Simple, declarative graphs for iOS.

## Introduction

![sample_1](docs/sample_1.png)

It's like, graphing... with caffeine.

Graffeine is an iOS library that uses CoreAnimation to render various types of data
graphs and charts. It is highly extendable and features a declarative interface,
modular layers, configuration binding, and auto-layout.

<br />


## Pieces and Parts


### GraffeineView

Subclass of UIView that manages and provides the rendering context for the various
graphing layers, which are divided into 5 *regions*:

               Top Gutter
            +---------------+
    Left    |     Main      | Right
    Gutter  |     Region    | Gutter
            +---------------+
              Bottom Gutter


Whenever a layer exists belonging to one of the regions, its positioning and size will
automatically be managed by the view, which includes responding to layout changes or
resizing events.

By default, `GraffeineView` contains no layers. You must add layers to it by setting
the `layers` property, like so:

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

*(abstract)* Container-like "graphing layer" used to represent a particular graph
component. By combining layers, you can dial in exactly the layout you want and
render amazing graphs.

Out of the box, there are a handful of ready-to-go graphing layers:

| GraffeineLayer                   | Displays                        |
|----------------------------------|---------------------------------|
| `GraffeineBarLayer`              |   vertical or horizontal bars   |
| `GraffeineGridLineLayer`         |   horizontal or vertical lines  |
| `GraffeineHorizontalLabelLayer`  |   labels arranged horizontally  |
| `GraffeineVerticalLabelLayer`    |   labels arranged vertically    |
| `GraffeinePieLabelLayer`         |   labels arranged circularly    |
| `GraffeinePlotLabelLayer`        |   labels arranged linearly      |
| `GraffeineLineLayer`             |   bezier line connecting data   |
| `GraffeinePieLayer`              |   segmented pies and donuts     |
| `GraffeinePlotLayer`             |   individual plots (points)     |


##### Constructing

When constructing a `GraffeineLayer`, you typically provide it with an `id` and
a `region`.

**id** is used to identify and access the layer after it has been added to a
`GraffeineView`:

    let pieLayer = graffeineView.layer(id: "pie")


**region** is the target area of the view to place the layer *(see GraffeineView)*

You can use any layer with any region, although some are more intended for certain
regions than others. For example, the horizontal and vertical label layers are
generally intended to be placed in one of the gutter regions.


##### Dimensional Unit

Certain properties, such as `unitWidth` or `diameter`, are defined as a
`DimensionalUnit`. This is an abstract unit type *(enum)*, that affects sizing
and positioning depending on which you specify:

 `.explicit( val )`   - literal number of pixels/points *(22.0 == 22px)*
 
 `.percentage( val )` - ratio size:container; fractional *(1.0 == 100%)*
 
 `.relative`          - automatic sizing based on the number
                        of units sharing the same container

<br />


### Value Labels

Out-of-the-box, there are three label options: horizontal, vertical, and radial.


##### Horizontal and Vertical Labels

![sample_2](docs/sample_2.png)

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

The `GraffeinePieLabelLayer` is primarily designed to be used in conjunction with
pie and donut charts, although they do work independently. For all intents and
purposes, positioning labels in the radial label layer works just like positioning
the pie slices.

<br />


## Interaction

### Setting Data

`GraffeineData` is the vehicle with which to pass data into Graffeine.
It's easy to apply new data to a specific layer by **assignment**:

    graffeineView.layer(id: "bar")?.data = GraffeineData(values: [1, 2, 3])
                                             
Or if you want it to **animate** whenever the data changes:

    graffeineView.layer(id: "pie")?
        .setData(GraffeineData(values: [1, 1, 2, 3, 5, 8, 13, 21]), 
                 animator: GraffeineDataAnimators.Pie.Spin(duration: 1.2,
                                                           timing: .easeInEaseOut))

*There are a handful of data animators included with the library, out-of-box, or you can
create your own, so long as it conforms to `GraffeineDataAnimating`.*

<br />


### Handling Selection

![sample_selection_1](docs/sample_selection_1.png)

Selection is divided into two parts, that of receiving user interaction, and that
of rendering the selection state.

##### Receiving touch events
All selection events are raised through `GraffeineView` via the `onSelect` handler.
By assigning a handler to this, you will start receiving events whenever the user
taps on the view.

In order to receive more granular events, you first need to tell it which layer(s)
you want to receive touch events for. Do this by setting the layer's
`selection.isEnabled` property to `true`:

    graffeineView.layer(id: "bars")?.selection.isEnabled = true

This only affects whether or not the layer will respond to user touch.

When enabled, the `onSelect` handler may include `SelectionResults`.

If either the `SelectionResult` or its `data.selectedIndex` is nil, we
can interpret it as "deselection". Otherwise, we should have all the
information we need in order to handle the event:
 
 - `point` is the view coordinate of the item that was selected, (in the
 coordinate-space of the `GraffeineView`). This is useful in case you wish to
 present some kind of pop-up UI and would like to attach any stems or other
 such elements to this point.

 - `data` is the layer's original data, updated to reflect the new selection state

 - `layer` is a reference to the GraffeineLayer that contains the selected item.
 Graffeine does NOT automatically update its state in response to a selection event.
 This is by design. If you just want to immediately display selection whenever the
 user taps on something, you can do that in the `onSelect` handler like so:

```
    graffeineView.onSelect = { selection in
        selection?.layer.setData(selection!.data, animator: barAnimator)
    }
```

##### Rendering selection

In order to render the selection changes, you need to first enable some overrides:

    graffeineView.layer(id: "bars")?.selection.fill.color = .green
    graffeineView.layer(id: "bars")?.selection.line.color = .black
    graffeineView.layer(id: "bars")?.selection.line.thickness = 3.0

Then, just include the `selectedIndex` whenever you set the data.

<br />


### Demo App

There is an iOS app,
*[graffeine-demo](https://github.com/quickthyme/graffeine-demo)*,
which demonstrates how to quickly go about composing many typical types of graphs. If
nothing else, it serves as an example of how to plug the library in and turn it on.

<br />
