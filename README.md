# KeyboardMaestroCLI
An unofficial command line utility for interfacing with Keyboard Maestro.

## RUNNING A MACRO:
```
km run "Display Notification" -p "Yippity Doo!"
```

### ARGUMENTS:
  <name-or-id>            Name or ID of the script to run

### OPTIONS:
```
  -p, --parameter <parameter>
                          Parameter to pass to your script
  -h, --help              Show help information.
```


### ALL SUBCOMMANDS:
```
  run                     Runs a macro
  edit                    Edits a macro
  enable                  Enables a macro
  disable                 Disables a macro
  macros                  List your macros
  groups                  List your macro groups
  variables               List your variables
  variable                Query, edit, delete variables
  raw                     Executes a raw script via XML
```
