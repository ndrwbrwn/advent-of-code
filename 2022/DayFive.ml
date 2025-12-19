module Stacks = Map.Make(Int);;

module DayFive = struct 
  let move_decode = fun a ->
    let n = Str.string_match (Str.regexp {|move \([0-9]+\) from \([0-9]+\) to \([0-9]+\)|}) a 0 in
    if n then
    let num_crates = int_of_string (Str.matched_group 1 a) in
    let from_stack = int_of_string (Str.matched_group 2 a) in
    let to_stack = int_of_string (Str.matched_group 3 a) in
    [|num_crates; from_stack; to_stack|]
    else [|0;0;0|]
  
  let rec get_last = fun (list) (recent) (index: int) ->
    if index == (List.length list) then recent else
    get_last list (List.nth list index) (index + 1)
  
  let rec get_last_n = fun (list) (gather) (n: int) (index: int) ->
    if index == (List.length list) then gather else
      if index >= (List.length list) - n then 
        get_last_n list (gather @ (List.cons (List.nth list index) [])) n (index + 1)
      else
        get_last_n list gather n (index + 1)
  
  let rec remove_last = fun (list) (gather) (index) ->
    if index == (List.length list) - 1 then gather else
    (*  *)
    remove_last list (gather @ (List.cons (List.nth list index) [])) (index + 1)
  
  let rec remove_last_n = fun (list) (gather) (n: int) (index: int) -> 
    if index == (List.length list) then gather else
      if index >= (List.length list) - n then 
        remove_last_n list gather n (index + 1)
      else
        remove_last_n list (gather @ (List.cons (List.nth list index) [])) n (index + 1)
  
  let rec move_all_crates = fun (stacks: ((String.t list) Stacks.t)) (from_stack: int) (to_stack: int) (num_crates: int) (current_crate: int) ->
    if current_crate == num_crates then stacks else (
      let old_from_stack = Stacks.find from_stack stacks in
      let moving_crate = get_last old_from_stack "" 0 in
      let stacks = Stacks.remove from_stack stacks in
      let stacks = Stacks.add from_stack (remove_last old_from_stack [] 0) stacks in
      let old_to_stack = Stacks.find to_stack stacks in
      (* add old + moving *)
      let stacks = Stacks.add to_stack (old_to_stack @ (List.cons moving_crate [])) stacks in
      move_all_crates stacks from_stack to_stack num_crates (current_crate + 1)
    )
  
  let move_all_crates_pt2 = fun (stacks: ((String.t list) Stacks.t)) (from_stack: int) (to_stack: int) (num_crates: int) ->
    let old_from_stack = Stacks.find from_stack stacks in
    let moving_crates = get_last_n old_from_stack [] num_crates 0 in
    let stacks = Stacks.remove from_stack stacks in
    let stacks = Stacks.add from_stack (remove_last_n old_from_stack [] num_crates 0) stacks in
    let old_to_stack = Stacks.find to_stack stacks in 
    Stacks.add to_stack (old_to_stack @ moving_crates) stacks

  let main (input: string) =              
    let rec do_moves = fun (moves: int array list) (stacks: ((String.t list) Stacks.t)) (index: int) ->
      if index >= List.length moves then stacks else (
        let num_crates = Array.get (List.nth moves index) 0 in
        let from_stack = Array.get (List.nth moves index) 1 in
        let to_stack = Array.get (List.nth moves index) 2 in
        (* change for pt1 or pt2 *)
        do_moves moves (move_all_crates_pt2 stacks from_stack to_stack num_crates) (index+1)
      )
    in
    
    let lines_of_input: string list = Str.split (Str.regexp "\n") input in
    
    let stacks = Stacks.empty in
    (* String parsing in OCaml is hell. Don't judge me for not bothering. *)
    let stacks = Stacks.add 1 (["L"; "N"; "W"; "T"; "D";];) stacks in
    let stacks = Stacks.add 2 (["C"; "P"; "H";];) stacks in
    let stacks = Stacks.add 3 (["W"; "P"; "H"; "N"; "D"; "G"; "M"; "J"];) stacks in
    let stacks = Stacks.add 4 (["C"; "W"; "S"; "N"; "T"; "Q"; "L"];) stacks in
    let stacks = Stacks.add 5 (["P"; "H"; "C"; "N"];) stacks in
    let stacks = Stacks.add 6 (["T"; "H"; "N"; "D"; "M"; "W"; "Q"; "B"];) stacks in
    let stacks = Stacks.add 7 (["M"; "B"; "R"; "J"; "G"; "S"; "L"];) stacks in
    let stacks = Stacks.add 8 (["Z"; "N"; "W"; "G"; "V"; "B"; "R"; "T"];) stacks in
    let stacks = Stacks.add 9 (["W"; "G"; "D"; "N"; "P"; "L"];) stacks in
    
    let input_moves = List.map move_decode lines_of_input in 
    
    let final_state = do_moves input_moves stacks 0 in
    
    let output = get_last (Stacks.find 1 final_state) "" 0 in
    let output = output ^ get_last (Stacks.find 2 final_state) "" 0 in
    let output = output ^ get_last (Stacks.find 3 final_state) "" 0 in
    let output = output ^ get_last (Stacks.find 4 final_state) "" 0 in
    let output = output ^ get_last (Stacks.find 5 final_state) "" 0 in
    let output = output ^ get_last (Stacks.find 6 final_state) "" 0 in
    let output = output ^ get_last (Stacks.find 7 final_state) "" 0 in
    let output = output ^ get_last (Stacks.find 8 final_state) "" 0 in
    let output = output ^ get_last (Stacks.find 9 final_state) "" 0 in
    output
end