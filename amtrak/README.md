## Getting started

### Prerequisites

In accordance with the Flatland competition, it is recommended to install [Anaconda](https://www.anaconda.com/distribution/) and create a new conda environment:
```
conda create python=3.8 --name amtrak
conda activate amtrak
```

📦 Then, install requirements, including the stable release of Flatland:
```
pip install -r doc/requirements.txt
```

📦 To have access to clingo, install the required package:
```
conda install -c conda-forge clingo
# or if that doesn't work:
# conda install -c potassco clingo
```

## Project Structure

Our project includes three different implementations:

- `base_solution.lp` : our initial solution where movement is on a cell by cell basis ()
- `graph_based_TODO.lp` : TODO
- `station_stops_solution.lp` : our base solution adapted to accomodate station stop along along a train's journey


### base_solution and graph_based_TODO - Solver

To run either the base_solution or graph_based_TODO implementations, uncomment the appropriate line in asp/params.py and run the solver as normal:

```
TODO: fill in with params
TODO: have Ted fill in the right params to run the graph based solution
# primary = ['amtrak/base_solution.lp', 'amtrak/track_options.lp']
secondary = []
```

The `primary` parameter is necessary, and is the standard suite of path planning encodings that return the appropriate `action(...)` output.  The `secondary` parameter is optional, and is primarily used when malfunctions are present in an environment.  Developers may choose to create a set of secondary encodings that help the replanning process necessary when faced with a train that has stalled.  For instance, it may be more efficient to consider the existing plan than to replan from the start.  More information about this is available in the 📁 `doc` folder.  If malfunctions are active and no `secondary` encoding is provided, the tooltik will call the `primary` set of encodings.

From the command line, call `python solve.py` along with a path to the `.pkl` form of the environment to test on, for example:
```
python solve.py envs/pkl/test.pkl
```

If successful, the output will be saved as a `.gif` (which by the way is pronounced [/dʒɪf/](https://www.abc.net.au/news/2018-08-10/is-it-pronounced-gif-or-jif/10102374) according to the creator of the format) animation, as well as a log file that details at each step what occurred in the simulation.


### station_stops_solution

#### Environment Generation

Unforunatly only the generation of the environment lp files is currently possible. In order to generate environments with stops, simply change the `number_of_stops` in envs/params.py to the number of stops you want to introduce per train and run build as usual:

```
python build.py 3
```

When generating lp files, pkl and png files will also be generated as normally (the process of lp file generation is currently dependant on the pkl file generation and could not be decoupled within the scope of this project), but since they will lack the stops functionality they should be ignored.  To run the implementation with stops, 




