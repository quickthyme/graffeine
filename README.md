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
    
    enum Region {
        case main, topGutter, rightGutter, bottomGutter, leftGutter
    }

Whenever a layer exists belonging to one of the regions, its positioning and size will automatically be managed by the view, which includes responding to layout changes or resizing events.

By default, `GraffeineView` contains no layers. You must add layers to it by setting the `layers` property, like so:

    graffeineView.layers = [
            GraffeineHorizontalGutter(id: "top", height: 16, region: .topGutter),
            
            GraffeineHorizontalGutter(id: "bottom", height: 26, region: .bottomGutter),
            
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

| GraffeineLayer               | Displays                                   |
|------------------------------|--------------------------------------------|
| `GraffeineBarLayer`          |   vertical or horizontal bars              |
| `GraffeineBarLayer`          |   horizontal or vertical grid lines        |
| `GraffeineHorizontalGutter`  |   labels arranged horizontally             |
| `GraffeineVerticalGutter`    |   labels arranged vertically               |
| `GraffeineLineLayer`         |   bezier line graph connecting data points |
| `GraffeinePieLayer`          |   segmented pie and donut charts           |
| `GraffeinePlotLayer`         |   individual plots (points)                |

When constructing a `GraffeineLayer`, you typically provide it with an `id` and a `region`.


##### id

The id is used to identify and access the layer after it has been added to a `GraffeineView`:

    let pieLayer = graffeineView.layer(id: "pie")


##### region

You can use any layer with any region, although some are more intended for certain regions than others. For example, the horizontal and vertical gutters are generally intended to be placed in one of the gutter regions.

<br />

### Setting Data

![sample_6](docs/sample_6.png)

It's easy to apply new data to a specific layer by just assigning it:

    graffeineView.layer(id: "pie")?.data = freshPieData


Or if you want it to animate whenever the data changes:

    graffeineView.layer(id: "pie")?.setData(freshPieData, animator: GraffeineDataAnimators.Pie.Spin(duration: 1.2, timing: .easeInEaseOut))

*There are a handful of data animators included with the library, out-of-box, or you can create your own custom animator so long as it conforms to `GraffeineDataAnimating`.*

<br />





### More

More features! More documentation!

There are plenty more features and graph types planned (and bugs yet to be introduced).

Stay tuned for more...

 <br />

...meanwhile, there is an iOS app, *[graffeine-demo](https://github.com/quickthyme/graffeine-demo)*,
which demonstrates how to quickly go about composing many typical types of graphs. If nothing else, it serves as an example of how to plug the library in and turn it on.

<br />
