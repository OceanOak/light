open Tea
open! Porting
module B = Blank
module P = Pointer
open Types

let spaceOf (hs : handlerSpec) : handlerSpace =
  let spaceOfStr s =
    let lwr = String.toLower s in
    if lwr = "cron" then HSCron else if lwr = "http" then HSHTTP else HSOther
  in
  match hs.module_ with Blank _ -> HSEmpty | F (_, s) -> spaceOfStr s

let visibleModifier (hs : handlerSpec) : bool =
  match spaceOf hs with
  | HSHTTP -> true
  | HSCron -> true
  | HSOther -> false
  | HSEmpty -> true

let replaceEventModifier (search : id) (replacement : string blankOr)
    (hs : handlerSpec) : handlerSpec =
  {hs with modifier= B.replace search replacement hs.modifier}

let replaceEventName (search : id) (replacement : string blankOr)
    (hs : handlerSpec) : handlerSpec =
  {hs with name= B.replace search replacement hs.name}

let replaceEventSpace (search : id) (replacement : string blankOr)
    (hs : handlerSpec) : handlerSpec =
  {hs with module_= B.replace search replacement hs.module_}

let replace (search : id) (replacement : string blankOr) (hs : handlerSpec) :
    handlerSpec =
  hs
  |> replaceEventModifier search replacement
  |> replaceEventName search replacement
  |> replaceEventSpace search replacement

let delete (pd : pointerData) (hs : handlerSpec) (newID : id) : handlerSpec =
  replace (P.toID pd) (Blank newID) hs

let rec allData (spec : handlerSpec) : pointerData list =
  [PEventName spec.name; PEventSpace spec.module_; PEventModifier spec.modifier]