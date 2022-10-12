(* SPDX-License-Identifier: MIT *)

module Term = Cmdliner.Term
module Arg = Cmdliner.Arg
module Manpage = Cmdliner.Manpage
module Cmd = Cmdliner.Cmd

let ( $ ) = Cmdliner.Term.( $ )
let ( & ) = Cmdliner.Arg.( & )

let main repos depends_on regexp_arg main_regexp =
  match regexp_arg, main_regexp with
  | Some _, Some _ -> `Error (true, "Two regexps given. This is not supported yet") (* TODO *)
  | None, None -> `Error (true, "No regexp given. This is required")
  | Some regexp, None
  | None, Some regexp -> `Ok (fun () -> Grep.search ~repos ~depends_on ~regexp)

let repos_arg =
  let doc = "" in (* TODO *)
  Arg.value &
  Arg.opt (Arg.some Arg.string) None &
  Arg.info ["repos"] ~docv:"REPOS" ~doc

let depends_on_arg =
  let doc = "" in (* TODO *)
  Arg.value &
  Arg.opt (Arg.some Arg.string) None &
  Arg.info ["depends-on"] ~docv:"PACKAGES" ~doc

let regexp_arg =
  let doc = "" in (* TODO *)
  Arg.value &
  Arg.opt (Arg.some Arg.string) None &
  Arg.info ["regexp"] ~docv:"REGEXP" ~doc

let main_regexp =
  let doc = "" in (* TODO *)
  Arg.value &
  Arg.pos ~rev:true 0 (Arg.some Arg.string) None &
  Arg.info [] ~docv:"REGEXP" ~doc

let cmd =
  let doc = "greps anything in the sources of the latest version of every opam packages" in
  let sdocs = Manpage.s_common_options in
  let exits = Cmd.Exit.defaults in
  let man = [] in (* TODO *)
  let term = Term.ret (Term.const main $ repos_arg $ depends_on_arg $ regexp_arg $ main_regexp) in
  let info = Cmd.info "opam-grep" ~version:Config.version ~doc ~sdocs ~exits ~man in
  Cmd.v info term

let () =
  exit @@ match Cmd.eval_value cmd with
  | Ok (`Ok f) ->
      begin try f (); 0 with
      | Grep.OpamGrepError msg -> prerr_endline ("Error: "^msg); 1
      end
  | Ok (`Version | `Help) -> 0
  | Error _ -> 1
