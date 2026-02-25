\# Renamer



A command-line file renaming tool written in OCaml.



\## Features



\- Replace spaces in filenames with underscores

\- Convert filenames to lowercase

\- Add a prefix to filenames

\- Dry-run mode to preview changes before applying them



\## Usage



renamer \[OPTIONS] \[DIRECTORY]



\## Options



| Flag | Description |

|------|-------------|

| --dry-run | Preview renames without applying them |

| --lowercase | Convert filenames to lowercase |

| --prefix text | Add a prefix to all filenames |

| --help | Show help message |



\## Examples



renamer .

renamer --dry-run .

renamer --lowercase .

renamer --prefix draft\_ .

renamer --prefix draft\_ --dry-run C:\\Users\\Delta1\\Documents



\## Building



Requires OCaml and dune.



dune build

dune exec renamer -- --help



\## License



MIT

