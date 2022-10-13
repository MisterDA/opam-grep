(* SPDX-License-Identifier: MIT *)

exception OpamGrepError of string

val search :
  repos:string option ->
  depends_on:string option ->
  regexp:string ->
  unit
