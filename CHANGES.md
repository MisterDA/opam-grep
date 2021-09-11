v0.2.0 (11/09/2021)
-------------------

- Complete rewrite from POSIX shell script to OCaml, making it more portable
- Use the faster `ripgrep` and `ugrep` over `grep` when available (suggestion from @Engil)
- Ignore read failures from grep (symlinks to unreachable files can make it fail)
- Use the `progress` library to show progress instead of a non-portable/DIY spinner
- Use the `cmdliner` library to handle arguments and produce a manpage via --help

v0.1.1 (20/06/2021)
-------------------

- Fix missing shell quotes resulting in the impossibility of having regexp with spaces in them

v0.1.0 (18/06/2021)
-------------------

- Just a simple shell script that greps in the sources of every opam packages
- General quality of life improvements by @dra27 in #1
