(* SPDX-License-Identifier: MIT *)

exception OpamGrepError of string

val search : repos:string option -> regexp:string -> unit
