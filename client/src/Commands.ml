open Types
open Tc

(* Dark *)
module TL = Toplevel

(* commands *)
let takeFunctionOffRail =
  { commandName = "take-function-off-rail"
  ; action = Refactor.takeOffRail
  ; doc = "Handle errors that arise from this function yourself"
  ; shortcut = "Alt-Shift-E" }


let putFunctionOnRail =
  { commandName = "put-function-on-rail"
  ; action = Refactor.putOnRail
  ; doc =
      "Errors that arise from this function will be handled on the error rail"
  ; shortcut = "Alt-E" }


let commands : command list =
  [ { commandName = "extract-function"
    ; action = Refactor.extractFunction
    ; doc = "Extract expression into a function"
    ; shortcut = "Ctrl-F" }
  ; { commandName = "extract-variable"
    ; action = Refactor.extractVariable
    ; doc = "Extract expression into a variable"
    ; shortcut = "Ctrl-Shift-L" }
  ; { commandName = "wrap-if-condition"
    ; action = Refactor.wrap Refactor.WIfCond
    ; doc =
        "Wrap the expression in an if, using the expression as the condition"
    ; shortcut = "Ctrl-Alt-C" }
  ; { commandName = "wrap-if-then"
    ; action = Refactor.wrap Refactor.WIfThen
    ; doc =
        "Wrap the expression in an if, putting this expression in the `then` body"
    ; shortcut = "Ctrl-I" }
  ; { commandName = "wrap-if-else"
    ; action = Refactor.wrap Refactor.WIfElse
    ; doc =
        "Wrap the expression in an if, putting this expression in the `else` body"
    ; shortcut = "Ctrl-Alt-I" }
  ; { commandName = "insert-let-above"
    ; action = Refactor.wrap Refactor.WLetBody
    ; doc = "Add a let on the line above"
    ; shortcut = "Ctrl-B" }
  ; { commandName = "wrap-in-let"
    ; action = Refactor.wrap Refactor.WLetRHS
    ; doc = "Wrap expression in a let"
    ; shortcut = "Ctrl-L" }
  ; { commandName = "add-feature-flag"
    ; action = FeatureFlags.wrap
    ; doc = "Clone expression as Case A in a feature flag"
    ; shortcut = "Alt-F" }
  ; putFunctionOnRail
  ; takeFunctionOffRail
  ; { commandName = "create-type"
    ; action =
        (fun m tl pd ->
          let tlid = TL.id tl in
          let id = Pointer.toID pd in
          let tipe =
            Analysis.getSelectedTraceID m tlid
            |> Option.andThen ~f:(Analysis.getLiveValue m id)
            |> Refactor.generateUserType
          in
          match tipe with
          | Ok tipe ->
              let nameId = Blank.toID tipe.utName in
              RPC ([SetType tipe], FocusNext (tipe.utTLID, Some nameId))
          | Error s ->
              DisplayError ("Can't create-type: " ^ s))
    ; doc = "Create a type from a live value"
    ; shortcut = "" } ]
